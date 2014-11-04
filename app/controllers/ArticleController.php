<?php

class ArticleController extends BaseController {

	public function getIndex() {
		return View::make('articles.index');
	}

	// public function showDetail($slug) {
	// 	return View::make('article.detail');
	// }

	// public function showNew($id) {
	// 	return View::make('article.new');
	// }

	// public function newArticle($id) {
		
	// }

	// public function showEdit($id) {
	// 	return View::make('article.edit');
	// }

}