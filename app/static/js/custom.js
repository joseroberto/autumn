/* Your JS codes here */

$(function(){
$('#tbl1').on('click', '.btn', function(e){
    var itemid = $(this).attr('item-id');
    var linha = $(this).closest('tr');
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
    },
    data: {id:itemid}
    });
});

$('#tbl2').on('click', '.btn', function(e){
    var itemid = $(this).attr('item-id');
    var linha = $(this).closest('tr');
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
    },
    data: {id:itemid}
    });
});
});		
