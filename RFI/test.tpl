<!DOCTYPE html>
<html>
<head>
    <title>Lecture de fichier</title>
</head>
<body>
    <h1>Contenu du fichier :</h1>
    <pre id="fileContent"></pre>
</body>
</html>
$(document).ready(function() {
    $.ajax({
        url: '/readfile', // L'URL à laquelle le serveur lit le fichier
        type: 'GET',
        dataType: 'text',
        success: function(data) {
            $('#fileContent').text(data);
        },
        error: function() {
            $('#fileContent').text('Erreur lors de la lecture du fichier.');
        }
    });
});
<script>
func readFileHandler(w http.ResponseWriter, r *http.Request) {
    filePath := "../../flag.txt" // Spécifiez le chemin vers le fichier que vous voulez lire.

    fileContent, err := readFileContents(filePath)
    if err != nil {
        http.Error(w, "Internal Server Error", http.StatusInternalServerError)
        return
    }

    w.Header().Set("Content-Type", "text/plain")
    w.Write([]byte(fileContent))
}
</script>
