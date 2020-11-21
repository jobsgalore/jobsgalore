class Category extends React.Component{
    constructor(props){
        super(props);
        this.state = { categories:[] };
    }
    componentDidMount(){
        $.ajax({
            type: "get",
            url: this.props.url_industries,
            success: function (data) {
                data.push({id: '', name: "Select category"});
                this.setState({categories: data});
            }.bind(this),
            dataType: 'json'
        });
    }

    render(){
        let options = this.state.categories.map(function (category) {
            return (<option key={category.id} selected={this.props.defaultValue ? category.id === this.props.defaultValue.id: false} value={category.id}>{category.name}</option>);
        }.bind(this));
        return(
            <select style={this.props.style} className={this.props.className} id = {this.props.id} name = {this.props.name}>
                {options}
            </select>
        );
    }
}