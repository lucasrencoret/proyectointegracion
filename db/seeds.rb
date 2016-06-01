# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


#Spree::Core::Engine.load_seed if defined?(Spree::Core)
Spree::Auth::Engine.load_seed if defined?(Spree::Auth)
Spree::Product.delete_all
Spree::Variant.delete_all


tax_category = Spree::TaxCategory.create(name: 'IVA',is_default: true)
tax_category.save

tax_rate = Spree::TaxRate.create(amount: 0.19, tax_category_id: 1, included_in_price: true)
tax_rate.save

product1 = Spree::Product.create(sku: "20", cost_currency: "CLP", name: "Cacao", description: "Este es un cacao", available_on: Time.now, meta_keywords: "Cacao", tax_category_id: 1, shipping_category_id: 1, promotionable: false, price: 1612)
#path = 'public/spree/products/20/product/cacao.jpeg'
#image = Spree::Image.create(attachment: File.open(path), viewable: product1.master, viewable_id: product1.id, viewable_type: 'Spree::Variant', attachment_file_name: "cacao.jpeg" , type: "Spree::Image")
#image.save
product1.save

product2 = Spree::Product.create(sku: "46", cost_currency: "CLP", name: "Chocolate", description: "Este chocolate ha sido creado con nuestro cacao personal y insumos de otros grupos", available_on: Time.now, meta_keywords: "Chocolate", tax_category_id: 1, shipping_category_id: 1, promotionable: false, price: 8514)
product2.save

product3 = Spree::Product.create(sku: "48", cost_currency: "CLP", name: "Pasta de Sémola", description: "Delicioso postre de dudosa procedencia", available_on: Time.now, meta_keywords: "Semola", tax_category_id: 1, shipping_category_id: 1, promotionable: false, price: 6627)
product3.save

product4 = Spree::Product.create(sku: "56", cost_currency: "CLP", name: "Hamburguesa de Pollo", description: "No se recomienda, mejor la de carne", available_on: Time.now, meta_keywords: "Hamburguesa", tax_category_id: 1, shipping_category_id: 1, promotionable: false, price: 5052)
product4.save



