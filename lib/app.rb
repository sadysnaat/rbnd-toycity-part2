require 'json'


def print_todays_date
	time = Time.new()
	puts time.strftime("%Y-%m-%d %H:%M:%S")
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
	puts "  _____       _             _____                       _"
	puts " / ____|     | |           |  __ \\                     | |"
	puts "| (___   __ _| | ___  ___  | |__) |___ _ __   ___  _ __| |_"
	puts " \\___ \\ / _` | |/ _ \\/ __| |  _  // _ \\ '_ \\ / _ \\| '__| __|"
	puts " ____) | (_| | |  __/\\__ \\ | | \\ \\  __/ |_) | (_) | |  | |_"
	puts "|_____/ \\__,_|_|\\___||___/ |_|  \\_\\___| .__/ \\___/|_|   \\__|"
	puts "                                      | |"
	puts "                                      |_|"
end

def print_product_banner
	# Print "Products" in ascii art
	puts "                     _            _       "
	puts "                    | |          | |      "
	puts " _ __  _ __ ___   __| |_   _  ___| |_ ___ "
	puts "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|"
	puts "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\"
	puts "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/"
	puts "| |                                       "
	puts "|_|                                       "
end

def print_brands_banner
	# Print "Brands" in ascii art
	puts " _                         _     "
	puts "| |                       | |    "
	puts "| |__  _ __ __ _ _ __   __| |___ "
	puts "| '_ \\| '__/ _` | '_ \\ / _` / __|"
	puts "| |_) | | | (_| | | | | (_| \\__ \\"
	puts "|_.__/|_|  \\__,_|_| |_|\\__,_|___/"
end

def print_seperator(number,character="*")
	puts character * number
end

def print_toy_title(title)
	puts title
end

def print_toy_prize(price)
	puts "Retail Price: $#{price}"
end

def calculate_toys_sales(purchases)
	return purchases.length
end

def print_toys_total_sales(purchases)
	total_sales = calculate_toys_sales(purchases)
	puts "Total Purchaeses: #{total_sales}"
end

def calculate_toys_sales_amount(purchases)
	purchases.inject(0.0) do |sum,purchase|
		sum + purchase["price"]
	end
end

def print_toys_sales_amount(purchases)
	total_sales_amount = calculate_toys_sales_amount(purchases)
	puts "Total Sales: $#{total_sales_amount}"
end

def calculate_toys_sales_average(purchases)
	sales_average = calculate_toys_sales_amount(purchases) / calculate_toys_sales(purchases)
	return sales_average
end

def print_average_sale_price(average_price)
	#average_price = calculate_toys_sales_average(purchases)
	puts "Average Price: $#{average_price}"
end

def calculate_average_discount(price,average_price)
	average_discount = ((price.to_f-average_price)/price.to_f*100).round(2) #round the value to two digits of decimal
end

def print_average_discount(price,average_price)
	average_discount = calculate_average_discount(price,average_price)
	puts "Average Discount: #{average_discount}%"
end

def print_toy_report(toy)
	print_toy_title(toy["title"])
	print_seperator(30)
	print_toy_prize(toy["full-price"])
	print_toys_total_sales(toy["purchases"])
	print_toys_sales_amount(toy["purchases"])
	average_price = calculate_toys_sales_average(toy["purchases"])
	print_average_sale_price(average_price)
	print_average_discount(toy["full-price"],average_price)
	print_seperator(30)
	print_seperator(2,"\n")
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
end

def start
	setup_files
	initialize_brand_date_hash
	print_sales_report_banner
	# Print today's date
	print_todays_date

	print_product_banner
	# For each product in the data set:
		# Print the name of the toy
		# Print the retail price of the toy
		# Calculate and print the total number of purchases
		# Calculate and print the total amount of sales
		# Calculate and print the average price the toy sold for
		# Calculate and print the average discount (% or $) based off the average sales price
	$products_hash["items"].each do |toy|
		print_toy_report(toy)
		generate_brand_date(toy)
	end
	print_brands_banner
	# For each brand in the data set:
		# Print the name of the brand
		# Count and print the number of the brand's toys we stock
		# Calculate and print the average price of the brand's toys
		# Calculate and print the total sales volume of all the brand's toys combined
end

start
