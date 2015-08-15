var Playgrid = React.createClass({
  getInitialState: function() {
    return {
      focussed_cell: null,
      defense: 1000,
      attack: 1000,
      level: "Some Level Name"
    };
  },
  getAttack: function() {
    return this.state.attack;
  },
  getDefense: function() {
    return this.state.defense;
  },
  getLevelName: function() {
    return this.state.level;
  },
  cellClicked: function(cell, event) {
    var element = event.target;
    var grid_container = this.refs.grid_container.getDOMNode();

    var elementRect = element.getBoundingClientRect();
    var containerRect = grid_container.getBoundingClientRect();

    var left = (elementRect.left + elementRect.width / 2) - containerRect.left;
    var top = (elementRect.top + elementRect.height / 2) - containerRect.top;

    this.setState({
      focussed_cell: cell
    });
  },
  render: function() {
    var self = this;
    return (
      <div className="playgrid">
        <div className="four columns">
          <dl className="your_score">
            <dt><strong>YOU</strong></dt>
            <dt>Defense: <span className="num">{self.getDefense()}</span></dt>
            <dt>Attack: <span className="num">{self.getAttack()}</span></dt>
          </dl>
        </div>
        <div className="four columns">
          <dl className="opponent_score">
            <dt><strong>MONSTER</strong></dt>
            <dt>Defense: <span className="num">{self.getDefense()}</span></dt>
            <dt>Attack: <span className="num">{self.getAttack()}</span></dt>
          </dl>
        </div>
        <div className="four columns right end">
          <p>LEVEL: <span className="levelname">{self.getLevelName()}</span></p>
          
          <button id="end_game" className="button-primary">End Game</button>
          <label for="end_game"><small>Give up?</small></label>
        </div>

        <div className="grid-container twelve columns" ref="grid_container">
          <Grid key="__editor" editor={false} cellClicked={this.cellClicked} ref="grid"/>
          {this.state.menu}
        </div>
      </div>
    );
  }
});
