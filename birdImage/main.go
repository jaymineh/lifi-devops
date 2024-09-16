package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
    "time"
	"net/http"
	"net/url"
	"github.com/prometheus/client_golang/prometheus"
    "github.com/prometheus/client_golang/prometheus/promhttp"
)

var (
	// Declare the metrics to be used.
    httpRequestsTotalbirdImageApi = prometheus.NewCounterVec(
        prometheus.CounterOpts{
            Name: "http_requests_total_to_birdimageapi",
            Help: "Total number of HTTP requests to birdimageapi",
        },
        []string{"method", "endpoint", "status"},
    )

    httpRequestDurationbirdImageApi = prometheus.NewHistogramVec(
        prometheus.HistogramOpts{
            Name:    "http_request_duration_seconds_to_birdimageapi",
            Help:    "Duration of HTTP requests in seconds to birdimageapi",
            Buckets: prometheus.DefBuckets,
        },
        []string{"method", "endpoint"},
    )
)

func init() {
	// Register the metrics
	prometheus.MustRegister(httpRequestsTotalbirdImageApi)
	prometheus.MustRegister(httpRequestDurationbirdImageApi)
}

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
	start := time.Now()
    defer func() {
        duration := time.Since(start)
        status := http.StatusOK
		httpRequestDurationbirdImageApi.WithLabelValues(r.Method, "/").Observe(duration.Seconds())
        httpRequestsTotalbirdImageApi.WithLabelValues(r.Method, "/", fmt.Sprint(status)).Inc()
    }()

	var buffer bytes.Buffer
    birdName := r.URL.Query().Get("birdName")
    if birdName == "" {
        json.NewEncoder(&buffer).Encode(defaultImage())
    } else {
        json.NewEncoder(&buffer).Encode(getBirdImage(birdName))
    }
	io.WriteString(w, buffer.String())
}

func main() {
	http.HandleFunc("/", bird)
	http.Handle("/metrics", promhttp.Handler())
	http.ListenAndServe(":4200", nil)
}

