=begin
 Implement a method #stock_picker that takes in an array of stock prices, 
 one for each hypothetical day. It should return a pair of days representing 
 the best day to buy and the best day to sell. Days start at 0.  
=end

def stock_picker(array_of_prices)
    best_buy_sell = [0,0]

    array_of_prices.each_with_index do |price, index|
        buy = price
        i = index
        while i <= array_of_prices.length - 1
            sell = array_of_prices[i]
            if sell - buy > best_buy_sell[1] - best_buy_sell[0]
                best_buy_sell[0] = buy
                best_buy_sell[1] = sell
                i += 1
            else
                i += 1
            end
        end
    end
    p "Buy and sell at #{best_buy_sell} for the most profit of $#{best_buy_sell[1] - best_buy_sell[0]}."
end

daily_prices = [17,3,6,9,15,8,6,1,10]

stock_picker(daily_prices)