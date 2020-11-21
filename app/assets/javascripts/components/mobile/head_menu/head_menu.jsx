class HeadMenu extends React.Component{
    constructor(props) {
        super(props);
        this.state={show: false};
        this.onClick = this.onClick.bind(this);
    }
    onClick(){
        this.setState({show: !this.state.show})
    }

    render() {
        const {root, industries_url, search} = this.props;
        const sizeGlyphicon = {fontSize: 20};
        return(<div>
            <a className="navbar-btn btn link" onClick={()=> this.onClick()}>
                <span className="glyphicon glyphicon-search" style={sizeGlyphicon}/>
            </a>
            <div className="pull-right">
                <a className="navbar-btn btn link" href={root}>
                    <span className="glyphicon glyphicon-home" style={sizeGlyphicon}/>
                </a>
            </div>
            <div className="col-xs-12 col-sm-12">
                <form action="/search"
                      acceptCharset="UTF-8"
                      method="get">
                      <Search key="mobile_search" name ='main_search' url_industries = {industries_url} search={search} show={this.state.show}/>
                </form>
            </div>
        </div>);
    }
}
