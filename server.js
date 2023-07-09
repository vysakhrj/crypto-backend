const express= require('express')
const app= express();
var bodyParser = require('body-parser');

const cors = require("cors");

const redstone = require('redstone-api');

const rp = require('request-promise');
const { default: async } = require('async');
const requestOptions = {
  method: 'GET',
  uri: 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest',
  qs: {
    'start': '1',
    'limit': '10',
    'convert': 'INR'
  },
  headers: {
    'X-CMC_PRO_API_KEY': '59bda0fd-d772-4f54-8ee2-86e4384c4797'
  },
  json: true,
  gzip: true
};




app.use(cors());

app.get('/top10',getTop10); 

app.get('/getPrice',getPrice);

async function getPrice(req,res){
    var symbol = req.query.symbol
    const price = await redstone.getPrice(symbol)
    res.send(price.symbol + ': '+ price.value)
}


async function getTop10(req,res){

    // const prices = await redstone.getPrice(["BTC", "ETH", "BNB", "SOL"]);

    // console.log(prices); // Example output below

    // console.log(await redstone.getPrice('BTC'))



    // console.log('BTC: '+prices["BTC"].value); // latest price value for BTC
    // console.log('ETH: '+prices["ETH"].value); // latest price value for ETH
    // console.log('BIN: '+prices["BNB"].value); // latest price value for BNB
    // console.log('SOL: '+prices["SOL"].value); // latest price value for SOL


    // res.send('AI app home')  

    rp(requestOptions).then(response => {
        // console.log('API call response:', response);
         result=[];
         data = response.data
        data.forEach(element => {
             getPriceFUN(element['symbol']).then((price)=>{
                
                var item = '#'+element['cmc_rank']+' '+ element['name']+ ' ('+element['symbol']+') $ ' + price.value
           
                result.push(item)
                console.log(item)
                
            })
            
        });
        return result

       
         
      }).then((result)=>{
        res.send(result)
      })
      .catch((err) => {
        console.log('API call error:', err.message);
      });
      
 
}

async function getPriceFUN(symbol) {
    return  await redstone.getPrice(symbol)
}


app.listen(3000);
console.log("app listening at 3000")



