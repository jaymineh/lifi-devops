package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"net/url"
)

type Urls struct {
    Thumb string
}

type Links struct {
    Urls Urls
}

type ImageResponse struct {
    Results []Links
}

type Bird struct {
	Image string
}

func defaultImage() string {
    return "https://www.pokemonmillennium.net/wp-content/uploads/2015/11/missingno.png"
}

func getBirdImage(birdName string) string {
    var query = fmt.Sprintf(
        "https://api.unsplash.com/search/photos?page=1&query=%s&client_id=P1p3WPuRfpi7BdnG8xOrGKrRSvU1Puxc1aueUWeQVAI&per_page=1",
        url.QueryEscape(birdName),
    )
	res, err := http.Get(query)
	if err != nil {
		fmt.Printf("Error reading image API: %s\n", err)
		return defaultImage()
	}
	body, err := io.ReadAll(res.Body)
	if err != nil {
		fmt.Printf("Error parsing image API response: %s\n", err)
		return defaultImage()
	}
	var response ImageResponse
	err = json.Unmarshal(body, &response)
	if err != nil {
		fmt.Printf("Error unmarshalling bird image: %s", err)
		return defaultImage()
	}
    return response.Results[0].Urls.Thumb
}

func bird(w http.ResponseWriter, r *http.Request) {
    birdName := r.URL.Query().Get("birdName")
    var imageURL string
    if birdName == "" {
        imageURL = defaultImage()
    } else {
        imageURL = getBirdImage(birdName)
    }

    // Set the content type to HTML
    w.Header().Set("Content-Type", "text/html")

    // Write HTML that embeds the image
    fmt.Fprintf(w, `
        <html>
            <body>
                <h1>Image of %s</h1>
                <img src="%s" alt="Image of %s">
                <p>Image URL: %s</p>
            </body>
        </html>
    `, birdName, imageURL, birdName, imageURL)
}

func main() {
	http.HandleFunc("/", bird)
	http.ListenAndServe(":4200", nil)
}
