const PAGE_SIZE = {
    small: 10,
    medium: 50,
    large: 200,
    huge: 500
};
class ChangeSize extends React.Component {
    constructor(props) {
        super(props);
        this.onChangeSize = this.onChangeSize.bind(this);
    }
    onChangeSize(size){
        if (this.props.page_size !== size) {
            this.props.onChangeSize({
                page: 0,
                page_size: size,
                page_count: Math.ceil(this.props.length / size)
            });
        }
    }
    render() {
        const RIGHT = {"textAlign": "right", "verticalAlign": "middle"};
        const SIZE_MARGIN = {"margin" : "5px 0"};
        return(<div className="col-lg-12">
                    <div style={RIGHT}>
                        <ul style={SIZE_MARGIN} className="pagination pagination">
                            {Object.values(PAGE_SIZE).map(function(size) {
                                return(<li  key = {size} className={this.props.page_size === size ? "active" : null}><a onClick={() => this.onChangeSize(size)}>{size}</a></li>);
                            }.bind(this))}
                        </ul>
                    </div>
                </div>);
    }
}
