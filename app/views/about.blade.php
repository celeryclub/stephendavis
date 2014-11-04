@extends('layout')

@section('title')
	About
@endsection

@section('content')

{{ Form::open(array('url' => 'my/route')) }}
    {{ Form::label('pandas_are_cute', 'Are pandas cute?') }}
    {{ Form::checkbox('pandas_are_cute', '1', true) }}
{{ Form::close() }}
	<div class="full-img-wrapper">
		<div class="full-img">
			<img src="{{ asset('img/im-on-a-lion.jpg') }}">
		</div>
	</div>
	<article>
		<p>I've been working in the web industry since 2005, and it's pretty great. Ruby is my favorite programming language, but I dabble in over <em>fifty </em>others. I am currently employed by <a href="http://www.j4studios.com/">J4 Studios</a>.</p>
		<blockquote class="skills">
			<h3>Sweet Skills</h3>
			<ul>
				<li>Ruby &amp; Rails &amp; Sinatra</li>
				<li>PHP &amp; Wordpress</li>
				<li>HTML 4/5</li>
				<li>CSS 2/3</li>
				<li>JavaScript &amp; AJAX &amp; jQuery</li>
				<li>Adobe CS5.5</li>
			</ul>
		</blockquote>
		<h2>Music</h2>
		<p>I like to write music in my spare time. I released an EP in 2009 that you can download for free from NoiseTrade – it’s called <a href="http://noisetrade.com/stephendavis">If Music be the Food of Love</a>. I have some of my newer work <a href="http://soundcloud.com/stephendavis89">posted on SoundCloud</a> too.</p>
		<p>In my spare time I write and record beautiful music and study Russian. Also programming.</p>
		<h2>Contact</h2>
		<p>If you're looking for my resume, try clicking this link: <a href="http://resume.stephendavis.im">resume link.</a> Feel free to contact me at any time of the day or night. My email address is <a href="mailto:hello@stephendavis.im?subject=Hello">hello@stephendavis.im</a>, or you can follow me on Twitter &mdash; <a href="http://twitter.com/stephendavis89/">@stephendavis89</a>.</p>
	</article>
@endsection
