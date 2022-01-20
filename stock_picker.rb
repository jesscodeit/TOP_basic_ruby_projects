=begin
 Implement a method #stock_picker that takes in an array of stock prices, 
 one for each hypothetical day. It should return a pair of days representing 
 the best day to buy and the best day to sell. Days start at 0.  
=end

def stock_picker(array_of_prices)
    # create variable to sell the best combo of prices
    best_buy_sell = [0,0]

    # look at each price individually
    array_of_prices.each_with_index do |price, index|

        # set the current price to the buy price
        buy = price

        # while the current price that has atleast one more price following it, do this
        while index <= array_of_prices.length - 1

            # set the current sell price to the current index count
            sell = array_of_prices[index]

            # if the current profit is bigger than the saved best profit, replace it
            if sell - buy > best_buy_sell[1] - best_buy_sell[0]
                best_buy_sell[0] = buy
                best_buy_sell[1] = sell
                index += 1
            else
                # increase index count either way
                index += 1
            end
        end
    end
    p "Buy and sell at #{best_buy_sell} for the most profit of $#{best_buy_sell[1] - best_buy_sell[0]}."
end

daily_prices = [17,3,6,9,15,8,6,1,10]

stock_picker(daily_prices)