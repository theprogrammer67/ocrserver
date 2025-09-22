package controllers

import (
	"github.com/otiai10/marmoset"
)

func renderError(render marmoset.Renderer, status int, err error) {
	if err == nil {
		return
	}
	render.JSON(status, map[string]interface{}{"error": err.Error()})
}
