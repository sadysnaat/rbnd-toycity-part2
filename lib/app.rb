require 'json'


def print_todays_date
	time = Time.new()
	$report_file.puts time.strftime("%Y-%m-%d %H:%M:%S")
end
#Read from json file to variable and set report output file
def setup_files
	path = File.join(File.dirname(__FILE__), '../data/products.json')
	file = File.read(path)
	$products_hash = JSON.parse(file)
	$report_file = File.new('report.txt','w+')
end

def initialize_brand_date_hash
	$brands_data = {}
end

def print_sales_report_banner
	# Print "Sales Report" in ascii art
	$report_file.puts "  _____       _             _____                       _"
	$report_file.puts " / ____|     | |           |  __ \\                     | |"
	$report_file.puts "| (___   __ _| | ___  ___  | |__) |___ _ __   ___  _ __| |_"
	$report_file.puts " \\___ \\ / _` | |/ _ \\/ __| |  _  // _ \\ '_ \\ / _ \\| '__| __|"
	$report_file.puts " ____) | (_| | |  __/\\__ \\ | | \\ \\  __/ |_) | (_) | |  | |_"
	$report_file.puts "|_____/ \\__,_|_|\\___||___/ |_|  \\_\\___| .__/ \\___/|_|   \\__|"
	$report_file.puts "                                      | |"
	$report_file.puts "                                      |_|"
end

def print_product_banner
	# Print "Products" in ascii art
	$report_file.puts "                     _            _       "
	$report_file.puts "                    | |          | |      "
	$report_file.puts " _ __  _ __ ___   __| |_   _  ___| |_ ___ "
	$report_file.puts "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|"
	$report_file.puts "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\"
	$report_file.puts "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/"
	$report_file.puts "| |                                       "
	$report_file.puts "|_|                                       "
end

def print_brands_banner
	# Print "Brands" in ascii art
	$report_file.puts " _                         _     "
	$report_file.puts "| |                       | |    "
	$report_file.puts "| |__  _ __ __ _ _ __   __| |___ "
	$report_file.puts "| '_ \\| '__/ _` | '_ \\ / _` / __|"
	$report_file.puts "| |_) | | | (_| | | | | (_| \\__ \\"
	$report_file.puts "|_.__/|_|  \\__,_|_| |_|\\__,_|___/"
end

def print_seperator(options={})
	number = options.fetch(:number,1)
	character = options.fetch(:character,"\n")
	$report_file.puts character * number
end

def print_toy_title(title)
	$report_file.puts title
end

def print_toy_prize(price)
	$report_file.puts "Retail Price: $#{price}"
end

def calculate_toys_sales(purchases)
	return purchases.length
end

def print_toys_total_sales(purchases)
	total_sales = calculate_toys_sales(purchases)
	$report_file.puts "Total Purchaeses: #{total_sales}"
end

def calculate_toys_sales_amount(purchases)
	purchases.inject(0.0) do |sum,purchase|
		sum + purchase["price"]
	end
end

def print_toys_sales_amount(purchases)
	total_sales_amount = calculate_toys_sales_amount(purchases)
	$report_file.puts "Total Sales: $#{total_sales_amount}"
end

def calculate_toys_sales_average(purchases)
	sales_average = calculate_toys_sales_amount(purchases) / calculate_toys_sales(purchases)
	return sales_average
end

def print_average_sale_price(average_price)
	#average_price = calculate_toys_sales_average(purchases)
	$report_file.puts "Average Price: $#{average_price}"
end

def calculate_average_discount(price,average_price)
	average_discount = ((price.to_f-average_price)/price.to_f*100).round(2) #round the value to two digits of decimal
end

def print_average_discount(price,average_price)
	average_discount = calculate_average_discount(price,average_price)
	$report_file.puts "Average Discount: #{average_discount}%"
end

def print_toy_report(toy)
	# Print the name of the toy
	print_toy_title(toy["title"])
	print_seperator(number:30,character:"*")
	# Print the retail price of the toy
	print_toy_prize(toy["full-price"])
	# Calculate and print the total number of purchases
	print_toys_total_sales(toy["purchases"])
	# Calculate and print the total amount of sales
	print_toys_sales_amount(toy["purchases"])
	# Calculate and print the average price the toy sold for
	average_price = calculate_toys_sales_average(toy["purchases"])
	print_average_sale_price(average_price)
		# Calculate and print the average discount (% or $) based off the average sales price
	print_average_discount(toy["full-price"],average_price)
	print_seperator(number:30,character:"*")
	print_seperator
end

def generate_brand_date(toy)
	#this code aggregates data on brands level
	#used later in this code
	if $brands_data.key?(toy["brand"])
		$brands_data[toy["brand"]]["no_of_products"] += toy["stock"]
		$brands_data[toy["brand"]]["prices"].push toy["full-price"]
	else
		$brands_data[toy["brand"]] = {"no_of_products"=>toy["stock"],"prices"=>[toy["full-price"]],"purchases"=>[]}
	end
	toy["purchases"].each do |purchase|
		$brands_data[toy["brand"]]["purchases"].push purchase["price"]
	end
end

def print_brand_name(name)
	$report_file.puts name
end

def print_brands_total_stock(total_stock)
	$report_file.puts "Number of Products: #{total_stock}"
end

def calculate_brans_average_price(price_data)
	return (price_data.inject(0.0) { |sum, price| sum + price.to_f } / price_data.size).round(2)
end

def print_brands_average_price(price_data)
	average_price = calculate_brans_average_price(price_data)
	$report_file.puts "Average Price: $#{average_price}"
end

def calculate_brands_total_sale(purchase_data)
	return purchase_data.inject(0.0) { |sum,purchase_amount| sum + purchase_amount }.round(2)
end

def print_brands_total_sale(purchase_data)
	total_sales = calculate_brands_total_sale(purchase_data)
	$report_file.puts "Total Sales: $#{total_sales}"
end

def print_brand_report(brand,brands_data)
	# Print the name of the brand
	print_brand_name(brand)
	print_seperator(number:30,character:"*")
	# Count and print the number of the brand's toys we stock
	print_brands_total_stock(brands_data["no_of_products"])
	# Calculate and print the average price of the brand's toys
	print_brands_average_price(brands_data["prices"])
	# Calculate and print the total sales volume of all the brand's toys combined
	print_brands_total_sale(brands_data["purchases"])
	print_seperator(number:30,character:"*")
	print_seperator
end

def start
	setup_files
	initialize_brand_date_hash
	print_sales_report_banner
	# Print today's date
	print_todays_date

	print_product_banner

	# For each product in the data set:
	$products_hash["items"].each do |toy|
		print_toy_report(toy)
		generate_brand_date(toy)
	end


	print_brands_banner

	# For each brand in the data set:
	$brands_data.each do |brand,brands_data|
		print_brand_report(brand,brands_data)
	end
end

start
