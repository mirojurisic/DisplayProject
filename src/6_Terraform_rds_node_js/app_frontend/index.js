var express = require('express');
var app = express();
var bodyParser = require('body-parser');

// set ejs as rendering engine
app.set('view engine', 'ejs');

// parse html forms
app.use(bodyParser.urlencoded({ extended: false }));

// render the ejs page
app.get('/', function (req, res) {
    res.render('index.ejs');
});

app.post('/postnote', function (req, res) {
    console.log(req.body.title + " is title.");
    console.log(req.body.contents + " is content.");
    console.log(JSON.stringify(req.body));
    fetch('http://localhost:8000/notes', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(req.body)
    })
        .then(response => response.json())
        .then(notes => {
            console.log('Success:', notes);
        })
        .catch((error) => {
            console.error('Error:', error);
        });
    res.redirect('/');
});
app.post('/notes', (req, res) => {
    let notes = [];
    fetch('http://localhost:8000/notes')
        .then(response => response.json())
        .then(data => {
            notes = data;
            console.log("oooo :", notes);
            res.render('notes.ejs', {
                notes: data
            })

        })
        .catch(error => console.error(error));

})
app.post('/deleteNote', function (req, res) {
    console.log(req.body.id + " is ID.");
    fetch('http://localhost:8000/notes/' + req.body.id, {
        method: 'DELETE',
        headers: {
            'Content-Type': 'application/json'
        },
    })
        .then(response => response.json())
        .then(notes => {
            console.log('Success:', notes);
        })
        .catch((error) => {
            console.error('Error:', error);
        });
    res.redirect('/');
});


app.listen(3000);
console.log('App is listening on PORT 3000');