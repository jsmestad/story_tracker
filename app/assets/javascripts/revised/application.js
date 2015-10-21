//= require jquery
//= require jquery_ujs
//= require_self

jQuery(document).ready(function() {

  var hash = window.location.hash;
  if (hash !== undefined) {
    $(hash).addClass('linked');
  }

  $('a.follow, a.unfollow').on('click', function(e) {
    e.preventDefault();

    var $link = $(this);
    if ($link.hasClass('follow')) {
      $.ajax({
        url: $link.attr('href'),
        method: 'POST',
        success: function(data) {
          $link.removeClass('follow').addClass('unfollow');
          $link.html('<span class="fa fa-eye-slash"/><span class="name">Unfollow</span>');
          $link.closest('.story').toggleClass('tracked');
        }
      });
    } else {
      $.ajax({
        url: $link.attr('href'),
        method: 'POST',
        data: {'_method': 'delete'},
        success: function(data) {
          $link.removeClass('unfollow').addClass('follow');
          $link.html('<span class="fa fa-eye"/><span class="name">Follow</span>');
          $link.closest('.story').toggleClass('tracked');
        }
      });
    }
  });



// var markdown_copy = '';

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
  // $('.stories .story .description').each(function(index, value) {
    // var $description = $(this);
    // $description.html(md.render($description.html()));

  // });
  // var result = md.render(markdown_copy);

  // TODO better way to show limited external stories
  $('div.story[data-local="false"] a.external').remove();

  $('div.story[data-local="true"] a.external').on('click', function(event) {
    // event.preventDefault();
    var $link = $(this);
    $.ajax({
        url: $link.data('url'),
        method: 'GET',
        success: function(data) {

          $('.cd-panel').addClass('is-visible');
          $('.cd-panel-content')
            .find('.name').html(data.data.attributes.name)
          .end()
            .find('.current-description').html(md.render(data.data.attributes.latest_description));
          $.each(data.data.attributes.versions, function(index, value) {
            var name;
            if(value.id == 0) {
              name = 'Original';
            } else {
              name = value.id;
            }
            $('.cd-panel-content').find('.version-history tbody').html('').append('<tr><td>'+name+'</td><td>'+value.comment+'</td><td>'+value.created_at+'</td></tr>');
          });
        }
      });
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

  // $('a.follow').on('click', function(event) {
    // event.preventDefault();
    // var $trackedLink = $(this);
    // if ($trackedLink.hasClass('fa-eye-slash')) {
      // $trackedLink.text(' Follow');
    // } else {
      // $trackedLink.text(' Unfollow');
    // }
    // $trackedLink.toggleClass('fa-eye-slash').toggleClass('fa-eye');
    // $trackedLink.closest('.story').toggleClass('tracked');
  // });
});
