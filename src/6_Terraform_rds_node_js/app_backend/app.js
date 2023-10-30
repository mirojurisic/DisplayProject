import express from 'express'

import { getNotes, getNote, createNote, deleteNote } from './database.js'

const app = express()
// handle errors
app.use(express.json())

app.get("/notes", async (req, res) => {

    const notes = await getNotes()
    res.send(notes)
})

app.get("/notes/:id", async (req, res) => {
    const id = req.params.id
    console.log(id)
    const note = await getNote(id)
    res.send(note)
})
app.delete("/notes/:id", async (req, res) => {
    const id = req.params.id
    const response = await deleteNote(id)
    res.send(response)
})
app.post("/notes", async (req, res) => {
    const { title, contents } = req.body
    const note = await createNote(title, contents)
    res.status(201).send(note)
})


app.use((err, req, res, next) => {
    console.error(err.stack)
    res.status(500).send('Something broke 💩')
})

app.listen(8000, () => {
    console.log('Server is running on port 8000')
})
