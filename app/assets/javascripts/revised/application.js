//= require jquery
//= require jquery_ujs
//= require_self

jQuery(document).ready(function() {



  $('a.follow, a.unfollow').on('click', function(e) {
    e.preventDefault();

    var $link = $(this);
    if ($link.hasClass('follow')) {
      $.ajax({
        url: $link.attr('href'),
        method: 'POST',
        success: function(data) {
          $link.hide();
          $link.siblings('a.unfollow').show();
        }
      });
    } else {
      $.ajax({
        url: $link.attr('href'),
        method: 'POST',
        data: {'_method': 'delete'},
        success: function(data) {
          $link.hide();
          $link.siblings('a.follow').show();
        }
      });
    }
  });



var markdown_copy = `## What is this?

Currently, all joins are implemented as sort-merge joins (https://en.wikipedia.org/wiki/Sort-merge_join).

In the very specific case where we are performing an equi-join of a relation (any relation) to a view and where the join condition is based on the primary key of the view, and where the partitioning of the join matches the partitioning of the view, then we can implement a highly optimized hash-join (https://en.wikipedia.org/wiki/Hash_join) instead of using a sort-merge join, where we perform the hash join co-located with the view partitions.

Until we implement #103668518 we can only co-locate whole streams, not subsets of the query plan, so for now there will be a further restriction that this optimization will only take place for the top level join in a stream in the case where a stream contains nested joins.

\`\`\`ruby
class Foo
  attr_accessor :first, :last

  def thing

  end
end
\`\`\`

## Urgency

This feature request is required in order to refactor the hazard flow at RMS to make it scalable.

## Stakeholders

* Cory Isaacson
* Dan Lynn

## Acceptance Criteria

* A relation-to-view join defaults to a hash-join implementation, in which the stream is shuffled so that each partition is co-located with the corresponding view partition (using the equi-join condition)
* For each tuple from the stream, the corresponding tuple is fetched from the view using an index lookup.
* Neither the stream nor the view is re-sorted.
* The output collation of the join is the same as the input collation of the stream
* If needed, guides are updated for this story.`;



  var md = window.markdownit({
    linkify: true,
    typographer: true,
    highlight: function (str, lang) {
      if (lang && hljs.getLanguage(lang)) {
        try {
          return hljs.highlight(lang, str).value;
        } catch (__) {}
      }

      try {
        return hljs.highlightAuto(str).value;
      } catch (__) {}

      return ''; // use external default escaping
    }
  });
  var result = md.render(markdown_copy);

  $('div.story a.external').on('click', function(event) {
		event.preventDefault();
		$('.cd-panel').addClass('is-visible');
    $('.cd-panel-content').html(result);
  });

  	//close the lateral panel
	$('.cd-panel').on('click', function(event){
		if( $(event.target).is('.cd-panel') || $(event.target).is('.cd-panel-close') ) {
			$('.cd-panel').removeClass('is-visible');
			event.preventDefault();
		}
	});

  // BEGIN - secondary nav
  //
	var secondaryNav = $('.cd-secondary-nav');
		// secondaryNavTopPosition = secondaryNav.offset().top,
		// taglineOffesetTop = $('#cd-intro-tagline').offset().top + $('#cd-intro-tagline').height() + parseInt($('#cd-intro-tagline').css('paddingTop').replace('px', '')),
		// contentSections = $('.cd-section');

	// $(window).on('scroll', function(){
		// //on desktop - assign a position fixed to logo and action button and move them outside the viewport
		// ( $(window).scrollTop() > taglineOffesetTop ) ? $('#cd-logo, .cd-btn').addClass('is-hidden') : $('#cd-logo, .cd-btn').removeClass('is-hidden');

		// //on desktop - fix secondary navigation on scrolling
		// if($(window).scrollTop() > secondaryNavTopPosition ) {
			// //fix secondary navigation
			// secondaryNav.addClass('is-fixed');
			// //push the .cd-main-content giving it a top-margin
			// $('.cd-main-content').addClass('has-top-margin');
			// //on Firefox CSS transition/animation fails when parent element changes position attribute
			// //so we to change secondary navigation childrens attributes after having changed its position value
			// setTimeout(function() {
							// secondaryNav.addClass('animate-children');
							// $('#cd-logo').addClass('slide-in');
				// $('.cd-btn').addClass('slide-in');
					// }, 50);
		// } else {
			// secondaryNav.removeClass('is-fixed');
			// $('.cd-main-content').removeClass('has-top-margin');
			// setTimeout(function() {
							// secondaryNav.removeClass('animate-children');
							// $('#cd-logo').removeClass('slide-in');
				// $('.cd-btn').removeClass('slide-in');
					// }, 50);
		// }

		//on desktop - update the active link in the secondary fixed navigation
		// updateSecondaryNavigation();
	// });

	function updateSecondaryNavigation() {
		contentSections.each(function(){
			var actual = $(this),
				actualHeight = actual.height() + parseInt(actual.css('paddingTop').replace('px', '')) + parseInt(actual.css('paddingBottom').replace('px', '')),
				actualAnchor = secondaryNav.find('a[href="#'+actual.attr('id')+'"]');
			if ( ( actual.offset().top - secondaryNav.height() <= $(window).scrollTop() ) && ( actual.offset().top +  actualHeight - secondaryNav.height() > $(window).scrollTop() ) ) {
				actualAnchor.addClass('active');
			}else {
				actualAnchor.removeClass('active');
			}
		});
	}

	//on mobile - open/close secondary navigation clicking/tapping the .cd-secondary-nav-trigger
	$('.cd-secondary-nav-trigger').on('click', function(event){
		event.preventDefault();
		$(this).toggleClass('menu-is-open');
		secondaryNav.find('ul').toggleClass('is-visible');
	});

	//smooth scrolling when clicking on the secondary navigation items
	// secondarynav.find('ul a').on('click', function(event){
        // event.preventdefault();
        // var target = $(this.hash);
        // $('body,html').animate({
          // 'scrolltop': target.offset().top - secondarynav.height() + 1
          // }, 400
        // );
        // //on mobile - close secondary navigation
        // $('.cd-secondary-nav-trigger').removeclass('menu-is-open');
        // secondarynav.find('ul').removeclass('is-visible');
    // });

    //on mobile - open/close primary navigation clicking/tapping the menu icon
	$('.cd-primary-nav').on('click', function(event){
		if($(event.target).is('.cd-primary-nav')) $(this).children('ul').toggleClass('is-visible');
	});


  //
  // END - secondary nav
});

$(document).ready(function() {

  $('a.follow').on('click', function(event) {
    event.preventDefault();
    var $trackedLink = $(this);
    if ($trackedLink.hasClass('fa-eye-slash')) {
      $trackedLink.text(' Follow');
    } else {
      $trackedLink.text(' Unfollow');
    }
    $trackedLink.toggleClass('fa-eye-slash').toggleClass('fa-eye');
    $trackedLink.closest('.story').toggleClass('tracked');
  });
});
