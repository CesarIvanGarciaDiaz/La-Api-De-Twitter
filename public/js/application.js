$(document).ready(main);

function main() {
    $(".enviar_al_form_usuario").click(function(e) {
        e.preventDefault();
        $('#carga').fadeIn(5);
        var twitter_handle = $("#myModal").find("textarea").val();
        if (twitter_handle == '') {
            alert("No puedes dejar campos vacios");
        } else {

          setTimeout(function() {
                  $(".carga").fadeOut(1000);
              },1200);

            $.post('/fetch', {

                twitter_handle: twitter_handle
            }, function(data) {

                $(".contenidotweet").append(data);
            });
            modal.style.display = "none";

        }

    });


    $(".enviar").click(function(e) {
        e.preventDefault();
        $('#carga').fadeIn(5);
        var text = $("#myModal2").find("textarea").val();
        if (text == '') {
            alert("No puedes dejar campos vacios");
        } else {
          setTimeout(function() {
                  $(".carga").fadeOut(1000);
              },800);
            $.post('/twitter', {
                text: text
            },function(data){
               $(".contenidotweet").append(data);
               console.log(data);
            });
            modal2.style.display = "none";
        }
    });

    $('.bt-menu').click(function(e) {
        e.preventDefault();

        $('nav#buscame').animate({
            left: "0%"
        });
    });

    $('.bt-menucross').click(function(e) {
        e.preventDefault();
        $('nav#buscame').animate({
            left: "-100%"
        });
    });



    // ____________________MODAL
    var modal = document.getElementById('myModal');

    // Get the button that opens the modal
    var btn = document.getElementById("myBtn");

    // Get the <span> element that closes the modal
    var span = document.getElementsByClassName("close")[0];

    btn.onclick = function() {
        modal.style.display = "block";
    }

    // When the user clicks on <span> (x), close the modal
    span.onclick = function() {
        modal.style.display = "none";
    }

    var modal2 = document.getElementById('myModal2');

    var btn2 = document.getElementById("myBtn2");

    var span2 = document.getElementsByClassName("close2")[0];

    btn2.onclick = function() {
        modal2.style.display = "block";
    }

    span2.onclick = function() {
        modal2.style.display = "none";
    }

    window.onclick = function(event) {
        if (event.target == modal) {
            modal.style.display = "none";
        }
        if (event.target == modal2) {
            modal2.style.display = "none";
        }
    }
}
