local M = {}

M = {
	categories = {
		{id= 1, name= 'Coffee'		, image= 'product_images/coffees.jpg'	 			},
		{id= 2, name= 'Cakes'		 	, image= 'product_images/cakes.jpg'					},
		{id= 3, name= 'Sandwiches', image= 'product_images/sandwiches.jpg'		},
		{id= 4, name= 'Salads'		, image= 'product_images/salads.jpg' 				}
	},

	products= {
		{id=1, category_id= 1, name= 'Espresso'                , image='product_images/1.jpg', price='€ 1.50', details='Espresso is coffee brewed by forcing a small amount of nearly boiling water under pressure through finely ground coffee beans.' },
		{id=2, category_id= 2, name= 'Carrot Cake'             , image='product_images/2.jpg', price='€ 3.50', details='Carrot cake is a cake or pie which contains carrots mixed into the batter. The carrot softens in the cooking process, and the cake usually has a soft, dense texture. The carrots themselves enhance the flavor, texture, and appearance of the cake.' },
		{id=3, category_id= 3, name= 'BLT'                     , image='product_images/3.jpg', price='€ 4.30', details='A BLT is a type of bacon sandwich. The standard BLT is made up of five ingredients: bacon, lettuce, tomato, mayonnaise, and bread.' },
		{id=4, category_id= 4, name= 'Caesar Salad'            , image='product_images/4.jpg', price='€ 5.10', details='A Caesar salad is a salad of romaine lettuce and croutons dressed with parmesan cheese, lemon juice, olive oil, egg, Worcestershire sauce, garlic, and black pepper. It is often prepared tableside.' },
		{id=5, category_id= 1, name= 'Cappucino'               , image='product_images/5.jpg', price='€ 2.70', details='A cappuccino, is an Italian coffee drink which is traditionally prepared with espresso, hot milk, and steamed-milk foam. The name comes from the Capuchin friars, referring to the colour of their habits' },
		{id=6, category_id= 2, name= 'Cheese Cake'             , image='product_images/6.jpg', price='€ 3.50', details='Cheesecake is a sweet dish consisting of two or more layers. The main, or thickest layer, consists of a mixture of soft, fresh cheese, eggs, and sugar.' },
		{id=7, category_id= 3, name= 'Ham and Cheese Sandwich' , image='product_images/7.jpg', price='€ 4.50', details='The ham and cheese sandwich is a common type of sandwich. It is made by putting cheese and sliced ham between two slices of bread. The bread is sometimes buttered and toasted.' },
		{id=8, category_id= 4, name= 'Coleslow'                , image='product_images/8.jpg', price='€ 3.90', details='Coleslaw, sometimes simply called slaw in some American dialects, is a salad consisting primarily of shredded raw cabbage, which is dressed with mayonnaise and/or buttermilk in some variations.' },
		{id=9, category_id= 4, name= 'Garden Salad'            , image='product_images/9.jpg', price='€ 4.90', details='A garden salad (also green salad or tossed salad) is a salad consisting mostly of fresh vegetables. The base for the salad are greens such as lettuce or mesclun.' },
		{id=10, category_id= 1, name= 'Caffee Latte'           , image='product_images/1.jpg', price='€ 4.90', details='A garden salad (also green salad or tossed salad) is a salad consisting mostly of fresh vegetables. The base for the salad are greens such as lettuce or mesclun.' },
		{id=11, category_id= 1, name= 'Caffee Affogato'        , image='product_images/1.jpg', price='€ 4.90', details='A garden salad (also green salad or tossed salad) is a salad consisting mostly of fresh vegetables. The base for the salad are greens such as lettuce or mesclun.' },
		{id=12, category_id= 1, name= 'Hot Chocolate'          , image='product_images/1.jpg', price='€ 4.90', details='A garden salad (also green salad or tossed salad) is a salad consisting mostly of fresh vegetables. The base for the salad are greens such as lettuce or mesclun.' },
		{id=13, category_id= 1, name= 'Soya Caffee'            , image='product_images/1.jpg', price='€ 4.90', details='A garden salad (also green salad or tossed salad) is a salad consisting mostly of fresh vegetables. The base for the salad are greens such as lettuce or mesclun.' },
		{id=14, category_id= 1, name= 'Americano'            	 , image='product_images/1.jpg', price='€ 4.90', details='A garden salad (also green salad or tossed salad) is a salad consisting mostly of fresh vegetables. The base for the salad are greens such as lettuce or mesclun.' },
	}
}

return M
