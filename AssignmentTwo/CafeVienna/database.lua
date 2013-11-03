-- DATABASE
--
-- This file contains all data about our products and categories.
-- This application is dynamic, so feel free to extend this database.
-- Category page is optimized for 4 categories. If you would like more categories
-- modify size parameters in categories.lua to fit in screen.


local M = {}

M = {
	categories = {
		{id= 1, name= 'Coffee'		, image= 'product_images/coffees.jpg'	 			},
		{id= 2, name= 'Cakes'		 	, image= 'product_images/cakes.jpg'					},
		{id= 3, name= 'Sandwiches', image= 'product_images/sandwiches.jpg'		},
		{id= 4, name= 'Salads'		, image= 'product_images/salads.jpg' 				}
	},

	products= {
		{id=1, category_id= 1, name= 'Espresso'        ,  image = 'product_images/1.jpg', price='€ 1.50', details='Espresso is coffee brewed by forcing a small amount of nearly boiling water under pressure through finely ground coffee beans.' },
		{id=2, category_id= 2, name= 'Carrot Cake'     ,  image = 'product_images/2.jpg', price='€ 3.50', details='Carrot cake is a cake or pie which contains carrots mixed into the batter. The carrot softens in the cooking process, and the cake usually has a soft, dense texture.' },
		{id=3, category_id= 3, name= 'BLT'             ,  image = 'product_images/3.jpg', price='€ 4.30', details='A BLT is a type of bacon sandwich. The standard BLT is made up of five ingredients: bacon, lettuce, tomato, mayonnaise, and bread.' },
		{id=4, category_id= 4, name= 'Caesar Salad'    ,  image = 'product_images/4.jpg', price='€ 5.10', details='A Caesar salad is a salad of romaine lettuce and croutons dressed with parmesan cheese, lemon juice, olive oil, egg, Worcestershire sauce, garlic, and black pepper. It is often prepared tableside.' },
		{id=5, category_id= 1, name= 'Cappuccino'      ,  image = 'product_images/5.jpg', price='€ 2.70', details='A cappuccino, is an Italian coffee drink which is traditionally prepared with espresso, hot milk, and steamed-milk foam. The name comes from the Capuchin friars, referring to the colour of their habits.' },
		{id=6, category_id= 2, name= 'Cheese Cake'     ,  image = 'product_images/6.jpg', price='€ 3.50', details='Cheesecake is a sweet dish consisting of two or more layers. The main, or thickest layer, consists of a mixture of soft, fresh cheese, eggs, and sugar.' },
		{id=7, category_id= 3, name= 'Ham and Cheese'  ,  image = 'product_images/7.jpg', price='€ 4.50', details='The ham and cheese sandwich is a common type of sandwich. It is made by putting cheese and sliced ham between two slices of bread. The bread is sometimes buttered and toasted.' },
		{id=8, category_id= 4, name= 'Coleslow'        ,  image = 'product_images/8.jpg', price='€ 3.90', details='Coleslaw, sometimes simply called slaw in some American dialects, is a salad consisting primarily of shredded raw cabbage, which is dressed with mayonnaise and/or buttermilk in some variations.' },
		{id=9, category_id= 4, name= 'Garden Salad'    ,  image = 'product_images/9.jpg', price='€ 4.90', details='A garden salad (also green salad or tossed salad) is a salad consisting mostly of fresh vegetables. The base for the salad are greens such as lettuce or mesclun.' },
		{id=10, category_id= 1, name= 'Latte'          ,  image = 'product_images/10.jpg', price='€ 2.70', details='A latte is a coffee drink made with espresso and steamed milk. The term as used in English is a shortened form of the Italian caffè latte or caffellatte, which means "milk coffee".' },
		{id=11, category_id= 1, name= 'Caffee Affogato',  image = 'product_images/11.jpg', price='€ 3.10', details='An affogato is a coffee-based beverage. It usually takes the form of a scoop of vanilla gelato or ice cream topped with a shot of hot espresso.' },
		{id=12, category_id= 1, name= 'Hot Chocolate'  ,  image = 'product_images/12.jpg', price='€ 2.90', details='Hot chocolate is a heated beverage typically consisting of shaved chocolate, melted chocolate or cocoa powder, heated milk or water, and sugar.' },
		{id=13, category_id= 1, name= 'Soy Cappuccino' ,  image = 'product_images/5.jpg', price='€ 4.90', details='Cappuccino with soy milk. Very healthy and great for lactose intolerants.' },
		{id=14, category_id= 1, name= 'Americano'      ,  image = 'product_images/1.jpg', price='€ 4.90', details='Americano is a style of coffee prepared by adding hot water to espresso, giving it a similar strength to, but different flavor from, regular drip coffee. Espresso and the amount of water added.' },
		{id=15, category_id= 2, name= 'Chocolate chip' ,  image = 'product_images/15.jpg', price='€ 2.50', details='A chocolate chip cookie is a drop cookie that originated in the United States and features chocolate chips as its distinguishing ingredient.' },
		{id=16, category_id= 2, name= 'Cupcake'       ,   image = 'product_images/16.jpg', price='€ 3.90', details='A cupcake is a small cake designed to serve one person, which may be baked in a small thin paper or aluminum cup. As with larger cakes, icing and other cake decorations, such as sprinkles, may be applied.' },
		{id=17, category_id= 2, name= 'Apple Tart'    ,   image = 'product_images/17.jpg', price='€ 4.50', details='An apple pie is a fruit pie (or tart) in which the principal filling ingredient is apples. It is sometimes served with whipped cream or ice cream on top, or alongside cheddar cheese.' },
		{id=18, category_id= 2, name= 'Tiramisu'       ,  image = 'product_images/18.jpg', price='€ 4.50', details='Tiramisu is a popular coffee-flavoured Italian dessert. It is made of ladyfingers dipped in coffee, layered with a whipped mixture of egg yolks, egg whites, sugar and mascarpone cheese, flavoured with cocoa.' },
		{id=19, category_id= 3, name= 'Club Sandwich'  ,  image = 'product_images/19.jpg', price='€ 4.30', details='A club sandwich, also called a clubhouse sandwich, is a sandwich with toasted bread. It is often cut into quarters and held together by sticks. It has two layers separated by an additional slice of bread.' },
		{id=20, category_id= 3, name= 'Hamburger'       , image = 'product_images/20.jpg', price='€ 5.10', details='A hamburger is a sandwich consisting of one or more cooked patties of ground meat placed inside a sliced hamburger bun. Served with lettuce, bacon, tomato, onion, pickles, cheese and condiments.' },
		{id=21, category_id= 3, name= 'Monte Cristo',     image = 'product_images/21.jpg', price='€ 4.50', details='A Monte Cristo is a fried ham and cheese sandwich, a variation of the French croque-monsieur. In the 1930s–1960s, American cookbooks had recipes for this sandwich, under such names as French Sandwich.' },
		{id=22, category_id= 3, name= 'Submarine Sandwich',image = 'product_images/22.jpg', price='€ 4.50', details='A submarine sandwich, also known as a sub, hoagie, hero, grinder, or one of many regional naming variations, is a sandwich that consists of a long roll of Italian or French bread.' },
		{id=23, category_id= 4, name= 'Chef Salad'       ,image = 'product_images/23.jpg', price='€ 4.10', details='Chef salad is a salad consisting of hard-boiled eggs; one or more varieties of meat, such as ham, turkey, chicken, or roast beef; tomatoes; cucumbers; and cheese.' },
		{id=24, category_id= 4, name= 'Egg Salad'       , image = 'product_images/24.jpg', price='€ 5.10', details='Egg salad is part of a tradition of salads involving a high-protein, low-carbohydrate, but usually high-fat food mixed with seasonings in the form of herbs, spices, and other foods, and bound with mayonnaise.' },
		{id=25, category_id= 4, name= 'Chicken Salad'    ,image = 'product_images/25.jpg', price='€ 5.10', details='Chicken salad is any salad that comprises chicken as a main ingredient. Other common ingredients may include mayonnaise, hard-boiled egg, celery, onion, pepper, pickles and a variety of mustards.' },
	}
}

return M
