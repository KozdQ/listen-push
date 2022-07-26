package main

import (
	"fmt"
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"listen-push/controller"
	"os"
)

func main() {
	// Create a gin router with default middleware
	router := gin.Default()
	config := cors.DefaultConfig()
	config.AllowAllOrigins = true
	config.AllowCredentials = true
	config.AllowHeaders = []string{"Content-Type", "Content-Length", "Accept-Encoding", "X-CSRF-Token", "Authorization", "accept", "Origin", "Cache-Control", "X-Requested-With"}
	router.Use(cors.New(config))

	// Main group routers
	listener := router.Group("/listen")
	listener.GET("/test", controller.ListenTest)
	listener.GET("/qpass/qpass-be/push", controller.ListenQPassBE)

	// router run
	port := os.Getenv("PORT")
	if port == "" {
		port = "8081"
	}
	err := router.Run(":" + port)
	if err != nil {
		fmt.Println(err)
		fmt.Println("==================")
		fmt.Println("Server can't run")
		fmt.Println("==================")
		return
	}
}
