import React from 'react';
import { render } from 'react-dom';
import {
  BrowserRouter,
  Switch,
  Route,
  NavLink,
} from 'react-router-dom';

import Search from './Search';
import MovieForm from './MovieForm';
import MovieShow from './MovieShow';

/**
 * App component: navbar + router
 */
const App = () => (
  <BrowserRouter>
    <header>
      <h1>Movie Database</h1>
      <NavLink to="/">Search movies</NavLink> |
      <NavLink to="/new-movie">Add movie</NavLink> |
      <a href="https://github.com/abodelot">My Github</a>
    </header>
    <Switch>
      <Route path="/new-movie">
        <MovieForm />
      </Route>
      <Route path="/movie/:id">
        <MovieShow />
      </Route>
      { /* default route, must be last */ }
      <Route path="/">
        <Search />
      </Route>
    </Switch>
  </BrowserRouter>
);

document.addEventListener('DOMContentLoaded', () => {
  render(
    <App />,
    document.body.appendChild(document.createElement('div')),
  );
});
