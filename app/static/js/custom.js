/* Your JS codes here */

$(function(){
$('#tbl').on('click', '.btn', function(e){
    var itemid = $(this).attr('item-id');
    var linha = $(this).closest('tr');
    var hora = linha.find('.hora');
    $.ajax({
    url: "/execute",
    async: false, 
    success: function(result){
        hora.html(result.hora);
    },
    data: {id:itemid}
    });
});
});		
