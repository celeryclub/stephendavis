<?php

class StaticController extends BaseController {

	public function showWelcome() {
		return View::make('hello');
	}

	public function showAbout() {
		return View::make('about');
	}

	public function showProjects() {
		return View::make('projects');
	}

}