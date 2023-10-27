package main

import (
    "fmt"
    "net/http"
)

func main() {
    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        if r.URL.Path == "/" {
            html := `
<!DOCTYPE html>
<html>
<head>
    <title>Lecture de fichier</title>
</head>
<body>
    <h1>Contenu du fichier :</h1>
    <pre id="fileContent"></pre>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function() {
            $.ajax({
                url: '/readfile',
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
    </script>
</body>
</html>
`
            w.Header().Set("Content-Type", "text/html")
            w.Write([]byte(html))
        }
    })

    http.HandleFunc("/readfile", func(w http.ResponseWriter, r *http.Request) {
        filePath := "chemin/vers/votre/fichier.txt" // Spécifiez le chemin vers le fichier que vous voulez lire

        fileContent, err := readFileContents(filePath)
        if err != nil {
            http.Error(w, "Internal Server Error", http.StatusInternalServerError)
            return
        }

        w.Header().Set("Content-Type", "text/plain")
        w.Write([]byte(fileContent))
    })

    fmt.Println("Serveur démarré à :1337")
    http.ListenAndServe(":1337", nil)
}
