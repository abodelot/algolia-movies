import React from 'react';
import { Link } from 'react-router-dom';

import ApiClient from '../ApiClient';
import ListEdit from './ListEdit';

/**
 * MovieForm: page for creating a new movie
 */
class MovieForm extends React.Component {
  constructor() {
    super();
    this.state = {
      movie: {
        title: null,
        alternative_titles: [],
        genres: [],
        year: null,
        image: null,
      },
      message: { text: '', status: '' },
    };
  }

  /**
   * Call the create movie API
   */
  createMovie(event) {
    ApiClient
      .post('/api/movies', { movie: this.state.movie })
      .then(() => {
        this.setState({
          message: {
            text: 'Movie created!',
            status: 'success',
          },
        });
      })
      .catch((error) => {
        this.setState({
          message: {
            text: error.response.data,
            status: 'error',
          },
        });
      });

    event.preventDefault();
  }

  render() {
    const { movie, message } = this.state;
    return (
      <form className="inner movie-form" onSubmit={this.createMovie.bind(this)}>
        <h2>Create a new movie</h2>
        <div className={`message-box ${message.status}`}>
          {message.text}
        </div>
        <div className="row">
          <label>Title</label>
          <input
            type="text"
            name="title"
            placeholder="Title"
            defaultValue={movie.title}
            onChange={(e) => { movie.title = e.target.value; }}
            required
          />
        </div>
        <div className="row">
          <label>Alternative titles:</label>
          <ListEdit
            items={movie.alternative_titles}
            itemName="alternative title"
            onUpdate={(values) => { movie.alternative_titles = values; }}
          />
        </div>

        <div className="row">
          <label>Genres:</label>
          <ListEdit
            items={movie.genres}
            itemName="genre"
            onUpdate={(values) => { movie.genres = values; }}
          />
        </div>

        <div className="row">
          <label>Image URL:</label>
          <input
            type="text"
            name="image"
            placeholder="https://..."
            defaultValue={movie.image}
            onChange={(e) => { movie.image = e.target.value; }}
            required
          />
        </div>

        <div className="row">
          <label>Background color:</label>
          <input
            type="color"
            name="color"
            defaultValue={movie.color}
            onChange={(e) => { movie.color = e.target.value; }}
          />
        </div>

        <div className="row">
          <label>Audience score:</label>
          <input
            type="number"
            name="score"
            min="0"
            max="10"
            step="0.01"
            placeholder="Score"
            defaultValue={movie.score}
            onChange={(e) => { movie.score = e.target.value; }}
            required
          />
        </div>

        <div className="row">
          <label>Rating:</label>
          <input
            type="number"
            name="rating"
            min="1"
            max="5"
            step="1"
            placeholder="Rating"
            defaultValue={movie.rating}
            onChange={(e) => { movie.rating = e.target.value; }}
            required
          />
        </div>

        <div className="row">
          <label>Year:</label>
          <input
            type="number"
            name="year"
            min="1900"
            max="2100"
            placeholder="Year"
            defaultValue={movie.year}
            onChange={(e) => { movie.year = e.target.value; }}
            required
          />
        </div>

        <div className="row">
          <button className="primary" type="submit">Create</button>
          <Link to="/">Cancel</Link>
        </div>
      </form>
    );
  }
}

export default MovieForm;
