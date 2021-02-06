import React from 'react';
import { withRouter } from 'react-router-dom';

import ApiClient from '../ApiClient';

/**
 * MovieShow: page to display a movie object, with a delete button.
 */
class MovieShow extends React.Component {
  constructor() {
    super();
    this.state = {
      movie: {
        alternative_titles: [],
      },
      message: {},
    };
  }

  componentDidMount() {
    // Fetch movie from API using ID parameter from URL
    const { id } = this.props.match.params;
    this.fetchMovie(id);
  }

  fetchMovie(id) {
    ApiClient
      .get(`/api/movies/${id}`)
      .then((response) => {
        this.setState({ movie: response.data });
      })
      .catch(() => {
        this.setState({
          message: { text: `Cannot fetch movie ${id}!`, status: 'error' },
        });
      });
  }

  deleteMovie() {
    if (window.confirm(`Are you sure to delete ${this.state.movie.title}?`)) {
      ApiClient
        .delete(`/api/movies/${this.state.movie.id}`)
        .then(() => {
          this.setState({
            movie: {},
            message: { text: 'Movie successfully delete!', status: 'success' },
          });
        })
        .catch(() => {
          this.setState({
            message: { text: 'Cannot delete movie!', status: 'error' },
          });
        });
    }
  }

  render() {
    const { movie, message } = this.state;

    return (
      <div className="inner">
        <div className={`message-box ${message.status}`}>
          {message.text}
        </div>
        {movie.id && (
          <div>
            <h2>{movie.title}</h2>
            <p>
              Alternative titles:
              {movie.alternative_titles.map((value) => (<span>{value}</span>))}
            </p>
            <p>Created at: {new Date(movie.created_at).toLocaleString()}</p>
            <p>Last update: {new Date(movie.updated_at).toLocaleString()}</p>
            <button
              type="button"
              name="delete"
              onClick={this.deleteMovie.bind(this)}
            >
              Delete movie
            </button>
          </div>
        )}
      </div>
    );
  }
}

export default withRouter(MovieShow);
