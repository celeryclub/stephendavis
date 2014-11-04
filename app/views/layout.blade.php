<!DOCTYPE HTML>
<html lang="en-US">
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<title>@yield('title') - Stephen Davis - Website design and devlopment in Greenville South Carolina</title>
		<meta name="description" content="">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link rel="stylesheet" href="{{ asset('css/normalize.css') }}">
		<link rel="stylesheet" href="{{ asset('css/main.css') }}">
		<script src="{{ asset('js/html5shiv.js') }}"></script>
	</head>
	<body>
		<div class="container">
			<header class="cf">
				<a href="{{ url('/') }}" class="logo">Stephen Davis</a>
				<nav class="main">
					<ul>
						@foreach($menuItems as $i => $menuItem)
							<li>{{ link_to($menuItem->url, $menuItem->text) }}</li>
							@if ($i < count($menuItems) - 1)
								<span class="seperator"> / </span>
							@endif
							@if($i == floor(count($menuItems) / 2) - 1)
								<span class="break"><br></span>
							@endif
						@endforeach
					</ul>
				</nav>
				<h1 class="page-title">@yield('title')</h1>
			</header>
			<main class="cf">
				<div class="primary">@yield('content')</div>
				<div class="secondary cf">
					<p>seCONDARY</p>
					<p>Current URL: {{ URL::current() }}</p>
					<p>Current route: {{ Route::currentRouteName() }}</p>
				</div>
			</main>
			<footer class="colophon cf">
				<p>&copy; {{ date('Y') }} Stephen Davis. Reservations are all right.</p>
			</footer>
		</div>
		<script src="{{ asset('js/jquery-1.10.2.min.js') }}"></script>
		<script src="{{ asset('js/jquery.fitvids.js') }}"></script>
		<script src="{{ asset('js/main.js') }}"></script>
		<script type="text/javascript">
			WebFontConfig = {
				google: { families: [ 'PT+Sans:400,700,400italic,700italic:latin', 'PT+Sans+Narrow:400,700:latin', 'Crete+Round:400,400italic:latin' ] }
			};
			(function() {
				var wf = document.createElement('script');
				wf.src = ('https:' == document.location.protocol ? 'https' : 'http') +
					'://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js';
				wf.type = 'text/javascript';
				wf.async = 'true';
				var s = document.getElementsByTagName('script')[0];
				s.parentNode.insertBefore(wf, s);
			})();
		</script>
	</body>
</html>
