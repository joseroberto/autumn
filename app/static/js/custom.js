/* Your JS codes here */

$(function(){
$('#tbl1').on('click', '.btn', function(e){
    var itemid = $(this).attr('item-id');
    console.log(itemid);
    var linha = $(this).closest('tr');
    console.log(linha);
    var prxlinha = linha.next('tr');
    console.log(prxlinha);
    var hora = linha.find('.hora');
    $.ajax({
        url: "/execute",
        async: false, 
        success: function(result){
            hora.html(result.hora);
            var label = linha.find('.botao');
            label.html('<i class="fa fa-check-square-o" aria-hidden="true"></i> Executado');
            label.parent().removeClass('btn-green');
            label.parent().addClass('btn-grey');
            label.parent().prop('disabled', function(i, v) { return !v; });
            if(prxlinha.length > 0){
                var label2 = prxlinha.find('.btn')
                label2.show();
            }else{
                console.log('Entrando na tbl2');
                var prxtabela = $('#tbl2');
                console.log(prxtabela);
                var prxlinha2 = prxtabela.children(1).find('tr:first');
                console.log(prxlinha2);
                var label3 = prxlinha2.find('.btn');
                console.log(label3);
                label3.show();
            }
        },
        data: {id:itemid}
    });
});

$('#tbl2').on('click', '.btn', function(e){
    var itemid = $(this).attr('item-id');
    var linha = $(this).closest('tr');
    var prxlinha = linha.next('tr');
    var hora = linha.find('.hora');
    $.ajax({
    url: "/execute",
    async: false, 
    success: function(result){
        hora.html(result.hora);
        var label = linha.find('.botao');
        label.html('<i class="fa fa-check-square-o" aria-hidden="true"></i> Executado');
        label.parent().removeClass('btn-green');
        label.parent().addClass('btn-grey');
        label.parent().prop('disabled', function(i, v) { return !v; });

        var label2 = prxlinha.find('.btn')
        label2.show();
    },
    data: {id:itemid}
    });
});
});		
