#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Importa roteiros de manobra a partir de PDFs para o banco SQLite.
Uso:
  python scripts/import_pdfs.py --roteiro 10 --pdf data/pdfs/roteiro_10.pdf --origem 3 --equipamento 999 --config "Texto configuração"
Ou para múltiplos PDFs (assumindo nomes roteiro_<id>.pdf):
  python scripts/import_pdfs.py --bulk data/pdfs
Requer: pdfplumber, unidecode
pip install pdfplumber unidecode

Heurísticas:
- Seção LIBERAÇÃO / NORMALIZAÇÃO define procedimento (1 ou 2)
- Itens iniciam com número:   1) descricao   | 1. descricao | 1 - descricao
- Equipamentos/Comandos extraídos por verbos: Fechar / Abrir -> comando 1 / 0
- Equipamento pelo padrão: \d{2}[A-Z][A-Z0-9]*(-\d)?

Limitações: Ajustar manualmente casos ambíguos.
"""
import re, sqlite3, argparse, json, pathlib, hashlib, datetime
try:
    import pdfplumber
except ImportError:
    pdfplumber = None
try:
    import unidecode
except ImportError:
    unidecode = None

DB_PATH = 'app/autman.db'
ITEM_RE = re.compile(r'^(\d+)[).\-]\s+(.*)$')
SECTION_RE = re.compile(r'(libera[cç]ao|normaliza[cç]ao)', re.IGNORECASE)
VERBO_COMANDO = re.compile(r'\b(Fechar|Abrir|Bloquear|Desbloquear)\b', re.IGNORECASE)
EQUIP_RE = re.compile(r'\b\d{2}[A-Z][A-Z0-9]*(-\d)?\b')

def norm(s):
    return unidecode.unidecode(s.lower()) if unidecode else s.lower()

def class_proc(line):
    l = norm(line)
    if 'liberac' in l: return 1
    if 'normaliz' in l: return 2
    return None

def parse_pdf(path):
    if pdfplumber is None:
        raise RuntimeError('pdfplumber não instalado')
    steps = []
    current_proc = None
    with pdfplumber.open(path) as pdf:
        for page in pdf.pages:
            text = page.extract_text() or ''
            for raw in text.splitlines():
                line = raw.strip()
                if not line:
                    continue
                if SECTION_RE.search(line):
                    current_proc = class_proc(line)
                    continue
                m = ITEM_RE.match(line)
                if m and current_proc:
                    numero = int(m.group(1))
                    desc = m.group(2).strip()
                    steps.append({'ordem': numero, 'descricao': desc, 'procedimento': current_proc})
                else:
                    if steps and current_proc:
                        steps[-1]['descricao'] += ' ' + line
    return steps

def extrai_comandos(descricao):
    comandos = []
    verbos = VERBO_COMANDO.findall(descricao)
    if not verbos:
        return comandos
    equipamentos = EQUIP_RE.findall(descricao)
    for v in verbos:
        cmd = 1 if v.lower().startswith('fech') else 0 if v.lower().startswith('abri') else None
        if cmd is None:
            continue
        for eq in equipamentos:
            comandos.append({'equipamento_codigo': eq, 'comando': cmd})
    return comandos

def get_equip_id(cur, codigo):
    r = cur.execute('select id from equipamento where codigo=?', (codigo,)).fetchone()
    return r[0] if r else None

def inserir(roteiro_id, origem_id, equipamento_id, config, steps, preview=False):
    con = sqlite3.connect(DB_PATH)
    cur = con.cursor()
    # garante roteiro
    r = cur.execute('select id from roteiro_manobra where id=?', (roteiro_id,)).fetchone()
    if not r:
        cur.execute('insert into roteiro_manobra (id,id_origem,id_equipamento,configuracao) values (?,?,?,?)', (roteiro_id, origem_id, equipamento_id, config))
    for st in steps:
        cur.execute('insert into roteiro_manobra_item (id_roteiro_manobra,descricao,id_unidade,procedimento) values (?,?,?,?)', (roteiro_id, st['descricao'], origem_id, st['procedimento']))
        item_id = cur.lastrowid
        for c in extrai_comandos(st['descricao']):
            equip_id = get_equip_id(cur, c['equipamento_codigo'])
            if equip_id:
                cur.execute('insert into roteiro_comando (id_roteiro_manobra_item,id_equipamento,comando) values (?,?,?)', (item_id, equip_id, c['comando']))
    if preview:
        con.rollback()
    else:
        con.commit()
    con.close()

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--roteiro', type=int, help='ID do roteiro para modo simples')
    ap.add_argument('--pdf', type=str, help='Arquivo PDF único')
    ap.add_argument('--origem', type=int, default=3, help='ID unidade origem (default=3 CTM)')
    ap.add_argument('--equipamento', type=int, default=0, help='ID equipamento principal (se criar novo roteiro)')
    ap.add_argument('--config', type=str, default='', help='Configuração texto')
    ap.add_argument('--bulk', type=str, help='Diretório com PDFs roteiro_<id>.pdf')
    ap.add_argument('--preview', action='store_true', help='Não grava, apenas simula')
    args = ap.parse_args()

    if args.bulk:
        d = pathlib.Path(args.bulk)
        for pdf in d.glob('roteiro_*.pdf'):
            rid = int(pdf.stem.split('_')[1])
            steps = parse_pdf(pdf)
            inserir(rid, args.origem, args.equipamento, args.config, steps, preview=args.preview)
            print(f'Importado roteiro {rid} com {len(steps)} itens')
        return

    if not (args.roteiro and args.pdf):
        ap.error('Usar --roteiro e --pdf juntos ou --bulk')
    steps = parse_pdf(pathlib.Path(args.pdf))
    inserir(args.roteiro, args.origem, args.equipamento, args.config, steps, preview=args.preview)
    print(f'Importado roteiro {args.roteiro} com {len(steps)} itens')

if __name__ == '__main__':
    main()
