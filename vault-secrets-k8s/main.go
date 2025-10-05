package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"
)

type SecretResponse struct {
	Username string `json:"username"`
	Password string `json:"password"`
	APIKey   string `json:"api_key"`
}

func getSecretFromVault() (*SecretResponse, error) {
	data, err := os.ReadFile("/vault/secrets/config")
	if err != nil {
		return nil, fmt.Errorf("failed to read vault secret: %w", err)
	}

	var secretResp SecretResponse
	if err := json.Unmarshal(data, &secretResp); err != nil {
		return nil, err
	}

	return &secretResp, nil
}

func secretHandler(w http.ResponseWriter, r *http.Request) {
	secret, err := getSecretFromVault()
	if err != nil {
		http.Error(w, fmt.Sprintf("Error retrieving secret: %v", err), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(secret)
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	fmt.Fprintln(w, "OK")
}

func main() {
	http.HandleFunc("/secret", secretHandler)
	http.HandleFunc("/health", healthHandler)

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	fmt.Printf("Server starting on port %s\n", port)
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		fmt.Printf("Server error: %v\n", err)
		os.Exit(1)
	}
}
