// convert unorderlist in two colm by adding new class
$('.stateUl').filter(function(){
    return this.childNodes.length > 10
}).addClass('twoColumns');

// change value of format to cvs
$("#download").click(function(){
    alert("The paragraph was clicked.");
    $('#format').val("csv");
});

// change value of format 
$("#search").click(function(){
    alert("The paragraph was clicked.");
    $('#format').val("");
});
