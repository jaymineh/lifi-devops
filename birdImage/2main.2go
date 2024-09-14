package main

import (
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
    defer res.Body.Close()
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
    if len(response.Results) == 0 {
        return defaultImage()
    }
    return response.Results[0].Urls.Thumb
}

func bird(w http.ResponseWriter, r *http.Request) {
    birdName := r.URL.Query().Get("birdName")
    if birdName == "" {
        birdName = "bird"
    }
    imageURL := getBirdImage(birdName)

    // Fetch the image
    resp, err := http.Get(imageURL)
    if err != nil {
        http.Error(w, "Failed to fetch image", http.StatusInternalServerError)
        return
    }
    defer resp.Body.Close()

    // Set the content type to the image type
    w.Header().Set("Content-Type", resp.Header.Get("Content-Type"))

    // Copy the image data to the response
    _, err = io.Copy(w, resp.Body)
    if err != nil {
        http.Error(w, "Failed to write image data", http.StatusInternalServerError)
        return
    }
}

func main() {
    http.HandleFunc("/", bird)
    fmt.Println("Server is running on http://localhost:4200")
    http.ListenAndServe(":4200", nil)
}
