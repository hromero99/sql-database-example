require("dotenv").config()
const mysql = require("mysql")
const faker = require("faker")
const connection = mysql.createConnection({
	"host": process.env.DB_HOST,
	"user": process.env.DB_USER,
	"password": process.env.DB_PASS,
	"database": process.env.DB_NAME
});

connection.connect();


for (let i = 0; i<20; i++){
	connection.query(`INSERT INTO aplicacion(NOMBRE) VALUES('${faker.name.firstName()}')`,(erro,rows,fields)=>{
		if (erro) throw erro
		console.log("Result");
	});
	connection.query(`INSERT INTO contenedor(id,NOMBRE,ESTADO) VALUES('${faker.datatype.number()}','${faker.name.firstName()}','${faker.random.alphaNumeric(5)}')`,(erro,rows,fields)=>{
		if (erro) throw erro
		console.log("Result");
	});
}

connection.query("select * from contenedor where id=94650",(erro,rows,fields) =>{
	console.log(fields);
	console.log(erro);
	console.log(rows);
});
connection.end();

