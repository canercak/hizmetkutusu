module HomePageHelpers
 
	def image_to_attach
		return Rails.root + 'app/assets/images/cini1.png'
	end
 

	def example_json
		  "{
	  'template_id': '1eef9f7099a911e3b49785752f8b363a',
	  'auth': {
	    'key': '****',
	    'max_size': 52428800,
	    'expires': '2014/07/14 12:10:57+00:00'
	  },
	  'notify_url': null,
	  'steps': {
	    'assembly_replay_import_provider_image1_0': {
	      'robot': '/http/import',
	      'url': 'http://tmp.transloadit.com.s3.amazonaws.com/eb6428a00b4b11e4905b0796ebb34431.jpg',
	      'force_name': 'images.jpg',
	      'force_original_id': 'eb6428a00b4b11e4905b0796ebb34431',
	      'field': 'provider_image1',
	      'use': [
	        'assembly_replay_import_provider_image1_0'
	      ]
	    },
	    'resize': {
	      'use': [
	        'assembly_replay_import_provider_image1_0'
	      ],
	      'robot': '/image/resize',
	      'width': 225,
	      'height': 225,
	      'resize_strategy': 'crop'
	    },
	    'export': {
	      'robot': '/s3/store',
	      'key': '****',
	      'secret': '****',
	      'bucket': 'hizmetkutusu',
	      'use': [
	        'assembly_replay_import_provider_image1_0'
	      ]
	    },
	    'resizebig': {
	      'use': [
	        'assembly_replay_import_provider_image1_0'
	      ],
	      'robot': '/image/resize',
	      'resize_strategy': 'fit',
	      'watermark_url': 'https://www.dropbox.com/s/awyrna8zdvi08nx/Selection_031.png',
	      'watermark_size': '25%',
	      'watermark_position': 'bottom-right'
	    },
	    'export2': {
	      'robot': '/s3/store',
	      'key': '****',
	      'secret': '****',
	      'bucket': 'hizmetkutusu',
	      'use': [
	        'assembly_replay_import_provider_image1_0'
	      ]
	    },
	    'resizemini': {
	      'use': [
	        'assembly_replay_import_provider_image1_0'
	      ],
	      'robot': '/image/resize',
	      'width': 25,
	      'height': 25,
	      'resize_strategy': 'crop'
	    },
	    'export3': {
	      'robot': '/s3/store',
	      'key': '****',
	      'secret': '****',
	      'bucket': 'hizmetkutusu',
	      'use': [
	        'assembly_replay_import_provider_image1_0'
	      ]
	    }
	  }
		}"
	end


	def fill_autocomplete(field, options = {})
	  fill_in field, with: options[:with] 
	  page.execute_script %Q{ $('##{field}').trigger('focus') }
	  page.execute_script %Q{ $('##{field}').trigger('keydown') }
	  selector = %Q{ul.ui-autocomplete li.ui-menu-item a:contains("#{options[:select]}")} 
	  page.should have_selector('ul.ui-autocomplete li.ui-menu-item a')
	  page.execute_script %Q{ $('#{selector}').trigger('mouseenter').click() }
	end

	def current_user
		User.first
	end
	
	def page!
	  save_and_open_page
	end
end
World(HomePageHelpers)