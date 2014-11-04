<?php

Route::get('/', function() {
	return View::make('index');
	// return Redirect::to('/second');
	// return Response::make('Hello world!', 200);
	// return Response::json($data);
});
Route::get('/projects', 'StaticController@showProjects');
Route::get('/about', 'StaticController@showAbout');

Route::group(array('before' => 'auth.basic'), function() {
	Route::controller('/blog', 'ArticleController');
	// Route::get('/blog', 'ArticleController@showIndex');
	// Route::get('/blog/{slug}', 'ArticleController@showDetail')->where('slug', '[A-Za-z]+');
	// Route::get('/blog/new', 'ArticleController@showNew');
	// Route::post('/blog', 'ArticleController@newArticle');
	// Route::get('/blog/{id}/edit', array(
	// 	'before' => 'auth.basic',
	// 	function($id) {
	// 		return View::make('blog.detail');
	// 	}
	// ))->where('id', '[0-9]+');
});

// Route::get('/nr', function()
// {
//  Input::flash();
//  return Redirect::to('new/request');
// });
// Route::get('new/request', function()
// {
// var_dump(Input::old());
// });
