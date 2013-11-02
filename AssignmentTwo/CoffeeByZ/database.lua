local M = {}

M = {
	categories = {
		{id= 1, name= 'Coffees'		    , image= 'images/coffees.jpg'	 },
		{id= 2, name= 'Cakes'		 	, image= 'images/cakes.jpg'			},
		{id= 3, name= 'Sandwiches'      , image= 'images/sandwiches.jpg' },
		{id= 4, name= 'Salads'		    , image= 'images/salads.jpg' },
	},

	products= {
		{id=1, category_id= 1, name= 'Espresso'                 },
		{id=2, category_id= 2, name= 'Carrot Cake'              },
		{id=3, category_id= 3, name= 'BLT'                      },
		{id=4, category_id= 4, name= 'Caeser Salad'             },
		{id=5, category_id= 1, name= 'Cappucino'                },
		{id=6, category_id= 2, name= 'Cheese Cake'              },
		{id=7, category_id= 3, name= 'Ham and Cheese Sandwich'  },
		{id=8, category_id= 4, name= 'Coleslow'                 }
	}
}

return M
