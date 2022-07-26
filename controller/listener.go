package controller

import (
	"bytes"
	"fmt"
	"github.com/gin-gonic/gin"
	"net/http"
	"os/exec"
	"strings"
)

func ListenTest(c *gin.Context) {
	cmd := exec.Command("chmod", "+x", "./script/test/restart.sh")
	stdout, err := cmd.Output()
	if err != nil {
		fmt.Printf("exec command error: %v\n", err.Error())
		c.JSON(http.StatusBadRequest, gin.H{"message": "exec chmod command error"})
		return
	}

	cmd = exec.Command("././script/test/restart.sh")
	stdout, err = cmd.Output()
	if err != nil {
		fmt.Printf("exec command error: %v\n", err.Error())
		c.JSON(http.StatusBadRequest, gin.H{"message": "exec restart command error"})
		return
	}
	fmt.Print(string(stdout))
	c.JSON(http.StatusOK, gin.H{"message": "pong"})
}

func ListenWebhookTest(c *gin.Context) {
	buf := new(bytes.Buffer)
	_, err := buf.ReadFrom(c.Request.Body)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "bind string error"})
		return
	}
	str := buf.String()
	if strings.Contains(str, "latest") {
		fmt.Println(str)

		cmd := exec.Command("chmod", "+x", "./script/test/restart.sh")
		stdout, err := cmd.Output()
		if err != nil {
			fmt.Printf("exec command error: %v\n", err.Error())
			c.JSON(http.StatusBadRequest, gin.H{"message": "exec chmod command error"})
			return
		}

		cmd = exec.Command("././script/test/restart.sh")
		stdout, err = cmd.Output()
		if err != nil {
			fmt.Printf("exec command error: %v\n", err.Error())
			c.JSON(http.StatusBadRequest, gin.H{"message": "exec restart command error"})
			return
		}
		fmt.Print(string(stdout))
		c.JSON(http.StatusOK, gin.H{"message": "pong"})
	} else {
		c.JSON(http.StatusOK, gin.H{"message": "not latest version"})
	}
}

func ListenQPassBE(c *gin.Context) {
	buf := new(bytes.Buffer)
	_, err := buf.ReadFrom(c.Request.Body)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "bind string error"})
		return
	}
	str := buf.String()
	if strings.Contains(str, "latest") {
		fmt.Println(str)
		cmd := exec.Command("chmod", "+x", "./script/qpass_qpass-be/restart.sh")
		stdout, err := cmd.Output()
		if err != nil {
			fmt.Printf("exec command error: %v\n", err.Error())
			c.JSON(http.StatusBadRequest, gin.H{"message": "exec chmod command error"})
			return
		}

		cmd = exec.Command("././script/qpass_qpass-be/restart.sh")
		stdout, err = cmd.Output()
		if err != nil {
			fmt.Printf("exec command error: %v\n", err.Error())
			c.JSON(http.StatusBadRequest, gin.H{"message": "exec restart command error"})
			return
		}
		fmt.Print(string(stdout))
		c.JSON(http.StatusOK, gin.H{"message": "pong"})
	} else {
		c.JSON(http.StatusOK, gin.H{"message": "not latest version"})
	}
}
