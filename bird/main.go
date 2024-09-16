package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"time"
	"io"
	"math/rand/v2"
	"net/http"
	"net/url"
	"github.com/prometheus/client_golang/prometheus"
    "github.com/prometheus/client_golang/prometheus/promhttp"

)

type Bird struct {
	Name        string
	Description string
	Image       string
}

var (
	// Declare the metrics to be used.
    httpRequestsTotalbirdApi = prometheus.NewCounterVec(
        prometheus.CounterOpts{
            Name: "http_requests_total_to_birdapi",
            Help: "Total number of HTTP requests to birdapi",
        },
        []string{"method", "endpoint", "status"},
    )

    httpRequestDurationbirdApi = prometheus.NewHistogramVec(
        prometheus.HistogramOpts{
            Name:    "http_request_duration_seconds_to_birdapi",
            Help:    "Duration of HTTP requests in seconds to birdapi",
            Buckets: prometheus.DefBuckets,
        },
        []string{"method", "endpoint"},
    )
)

func init() {
	// Register the metrics
	prometheus.MustRegister(httpRequestsTotalbirdApi)
	prometheus.MustRegister(httpRequestDurationbirdApi)
}

func defaultBird(err error) Bird {
	return Bird{
		Name:        "Bird in disguise",
		Description: fmt.Sprintf("This bird is in disguise because: %s", err),
		Image:       "https://www.pokemonmillennium.net/wp-content/uploads/2015/11/missingno.png",
	}
}

func getBirdImage(birdName string) (string, error) {
    // Update the URL to use the Kubernetes service name and port
    url := fmt.Sprintf("http://birdimageapi:4200?birdName=%s", url.QueryEscape(birdName))
    
    res, err := http.Get(url)
    if err != nil {
        return "", err
    }
    defer res.Body.Close()
    body, err := io.ReadAll(res.Body)
    if err != nil {
        return "", err
    }
    return string(body), nil
}

func getBirdFactoid() Bird {
	res, err := http.Get(fmt.Sprintf("%s%d", "https://freetestapi.com/api/v1/birds/", rand.IntN(50)))
	if err != nil {
		fmt.Printf("Error reading bird API: %s\n", err)
		return defaultBird(err)
	}
	body, err := io.ReadAll(res.Body)
	if err != nil {
		fmt.Printf("Error parsing bird API response: %s\n", err)
		return defaultBird(err)
	}
	var bird Bird
	err = json.Unmarshal(body, &bird)
	if err != nil {
		fmt.Printf("Error unmarshalling bird: %s", err)
		return defaultBird(err)
	}
    birdImage, err := getBirdImage(bird.Name)
    if err != nil {
        fmt.Printf("Error in getting bird image: %s\n", err)
        return defaultBird(err)
    }
    bird.Image = birdImage
	return bird
}

func bird(w http.ResponseWriter, r *http.Request) {
	start := time.Now()
    defer func() {
        duration := time.Since(start)
        status := http.StatusOK
		httpRequestDurationbirdApi.WithLabelValues(r.Method, "/").Observe(duration.Seconds())
        httpRequestsTotalbirdApi.WithLabelValues(r.Method, "/", fmt.Sprint(status)).Inc()
    }()

	var buffer bytes.Buffer
	json.NewEncoder(&buffer).Encode(getBirdFactoid())
	io.WriteString(w, buffer.String())
}

func main() {
	http.HandleFunc("/", bird)
	http.Handle("/metrics", promhttp.Handler())
	http.ListenAndServe(":4201", nil)
}
