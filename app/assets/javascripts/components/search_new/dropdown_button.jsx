//Выпадающие кнопки нижнего ряда
class DropdownButton extends React.Component{
    constructor(props){
        super(props);
        const elements = this.props.elements;
        let defaultElem = elements.find(function (elem) {
            return elem.code == this.props.defaultValue
        }.bind(this));
        this.state = {
            name: defaultElem ?  defaultElem.name : elements[0].name,
            code: defaultElem ?  defaultElem.code : elements[0].code
        };
        this.handleClickItem = this.handleClickItem.bind(this);
    }

    handleClickItem(e) {
        if (e.target.id.indexOf(this.props.name) !== -1) {
            this.setState({
                name: e.target.text,
                code: e.target.dataset.id });
        }
    }

    render(){
        const {elements, name} = this.props;
        let li = elements.map(function (elem, i) {
            return(<li key={`${name}_${i}`}>
                <a id={`${name}_${i}`}  data-id={elem.code}  onClick={this.handleClickItem}>
                    {elem.name}
                </a>
            </li>);
        }.bind(this));
        let input = null;
        if (this.state.code != elements[0].code ){
            input = <input id="input_action" name={name} hidden={true} value={this.state.code} readOnly={true}/>;
        }
        return(<div key={name} className="form-group" >
                <div className="dropdown" key={name}>
                    <button className="btn btn-default dropdown-toggle btn-lg select_search max_button" type="button" data-toggle="dropdown"
                            aria-haspopup="true">
                        {this.state.name}
                    </button>
                    <ul className="dropdown-menu dropdown-menu-height">
                        {li}
                    </ul>
                </div>
                {input}
            </div>
        )
    }
}

