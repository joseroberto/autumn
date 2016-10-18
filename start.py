#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
    Autman
    ~~~~~~
    Sistema de automanção de manobras.
    :copyright: (c) 2015 by Sergio Dias.
"""
from app import app

if __name__ == "__main__": 
    app.run(host='0.0.0.0', port=5000)