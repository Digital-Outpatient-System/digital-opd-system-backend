require('dotenv').config();
const {Pool, Query} = require('pg');

const pool = new Pool({
    connectionString: process.env.DATABASE_URL,
    ssl:{
        rejectUnauthorized:false //for secure cloud connection
    }
});

//test connection with db when server starts
pool.connect((err,client,release)=>{
    if(err){
        console.error("Database connection failed",err.stack);
    }
    else{
        console.log("Database successfully connection to Belihuloya cloud database");
        release();
    }
});

module.exports = {
    query: (text,params) => pool.query(text,params)
};