import React from 'react';
import {
  InstantSearch, SearchBox, Hits, Highlight, Stats, Pagination,
} from 'react-instantsearch-dom';
import { Link } from 'react-router-dom';
import algoliasearch from 'algoliasearch/lite';

import StarRating from './StarRating';

const searchClient = algoliasearch('DJ6C01D4GV', 'f6c0c54fd3ecefe451dc186c18710680');

const Card = ({ hit }) => (
  <Link className="card" to={`/movie/${hit.id}`}>
    <div className="card-image" style={{ background: hit.color }}>
      <img src={hit.image} alt={hit.name} className="image" />
    </div>
    <div className="card-content">
      <Highlight attribute="title" hit={hit} className="card-title" tagName="span" />
      <div className="card-genres">
        {hit.genres.map((value) => (<span key={value}>{value}</span>))}
      </div>
      <Highlight attribute="year" hit={hit} className="card-year" />
      <div className="card-rating">
        <span className="card-label">Rating:</span>
        <StarRating rating={hit.rating} />
      </div>
      <div className="card-score">
        <span className="card-label">Audience score:</span> {hit.score.toFixed(2)}/10
      </div>
      <div className="card-actors">
        <span className="card-label">Starring:&nbsp;</span>
        {
          // Display the first 3 actors
          hit.actors.slice(0, 3).map((value) => (<span key={value}>{value}, </span>))
        }
      </div>
    </div>
  </Link>
);

/**
 * Search component:
 * Use Algolia InstantSearch and display hits in grid layout.
 * Each result links to MovieShow using internal movie ID.
 */
const Search = () => (
  <InstantSearch searchClient={searchClient} indexName="Movie">
    <div className="search-wrapper">
      <SearchBox
        className="search-bar"
        translations={{ placeholder: 'Search for Movies' }}
      />
      <h2 className="subtitle">Powered by Algolia</h2>
    </div>
    <div className="content">
      <div className="search-stats">
        <Stats />
      </div>
      <Hits hitComponent={Card} />
      <Pagination />
    </div>
  </InstantSearch>
);

export default Search;
