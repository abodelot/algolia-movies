import React from 'react';

/**
 * A generic component for editing a list of strings with text inputs
 * prop items: array of values
 * prop itemName: label to be displayed
 * prop onUpdate: callback function to send updated values
 */
class ListEdit extends React.Component {
  constructor(props) {
    super(props);

    // A bit hacky, but props should not be mutated.
    // Use a random id as key, so react can keep track of each element in render
    // loop (cannot use the value itself as key because it is mutated!).
    this.state = {
      items: props.items.map((item) => ({ dom_id: Math.random(), value: item })),
    };
  }

  setItemAt(index, value) {
    this.state.items[index].value = value;
    this.refresh();
  }

  addItem() {
    this.state.items.push({ dom_id: Math.random(), value: '' });
    this.refresh();
  }

  deleteItemAt(index) {
    this.state.items.splice(index, 1);
    this.refresh();
  }

  refresh() {
    this.forceUpdate();
    this.props.onUpdate(this.state.items.map((item) => item.value));
  }

  render() {
    return (
      <div className="list-edit">
        {
          this.state.items.map((obj, index) => (
            <div key={obj.dom_id}>
              <input
                type="text"
                placeholder={`${this.props.itemName} ${index + 1}`}
                defaultValue={obj.value}
                onChange={(e) => { this.setItemAt(index, e.target.value); }}
              />
              <button
                type="button"
                onClick={() => { this.deleteItemAt(index); }}
                title="Remove"
              >
                &times;
              </button>
            </div>
          ))
        }
        <button type="button" onClick={this.addItem.bind(this)}>
          Add {this.props.itemName}
        </button>
      </div>
    );
  }
}

export default ListEdit;
