function loadInfinitePost()	
{
	if(jQuery('#infinite_loading_status').val() == 0)
	{
		var currentOffset = parseInt(jQuery('#infinite_loading_offset').val());
		jQuery('#infinite_loading').addClass('visible');
	
		jQuery.ajax({
	        url: 'https://themes.themegoods.com/grandblog/demo/wp-admin/admin-ajax.php',
	        type:'POST',
	        data: 'action=grandblog_post&current_query=a:1:{s:14:"posts_per_page";s:1:"6";}&items=12&items_ini=6&offset='+currentOffset+'&columns=2&tg_security='+tgAjax.ajax_nonce, 
	        success: function(html)
	        {
	        	jQuery('#infinite_loading_offset').val(parseInt(currentOffset+6));
	        	jQuery('#infinite_scroll_wrapper').append(html);
				jQuery('#infinite_loading').removeClass('visible');
	        }
	    });
	}
}

jQuery(window).load(function(){ 
	jQuery(document).ajaxStart(function() {
	  	jQuery('#infinite_loading_status').val(1);
	});
	
	jQuery(document).ajaxStop(function() {
	  	jQuery('#infinite_loading_status').val(0);
	});

	if (jQuery(document).height() <= jQuery(window).height())
	{
        var currentOffset = parseInt(jQuery('#infinite_loading_offset').val());
		var total = parseInt(jQuery('#infinite_loading_total').val());
		
		if (currentOffset > total)
	    {
	        return false;
	    }
	    else
	    {
	        loadInfinitePost();
	    }
    }

	jQuery(window).on('scroll', function() {
		var currentOffset = parseInt(jQuery('#infinite_loading_offset').val());
		var total = parseInt(jQuery('#infinite_loading_total').val());
		
		wrapperHeight = jQuery('#infinite_scroll_wrapper').height()+jQuery('#infinite_scroll_wrapper').offset().top;
	
	    if(jQuery(window).scrollTop() >= parseInt(jQuery(document).height() - wrapperHeight))
	    {
	    	if (currentOffset >= total)
	    	{
	    		return false;
	    	}
	    	else
	    	{
	    		loadInfinitePost();
	    	}
	    }
	});
});