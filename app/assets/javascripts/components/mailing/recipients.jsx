class Recipients extends React.Component {
    constructor(props) {
        super(props);
    }

    render(){
        const CENTER = {"textAlign": "center", "verticalAlign": "middle"};
        let star = function (bool) {
            if (bool){
                return(<span className="glyphicon glyphicon-star"/>);
            }
        };
        let thead = <thead>
        <tr>
            <th>Company</th>
            <th>Recipient</th>
            <th>Head office</th>
            <th>Area</th>
        </tr>
        </thead>;
        let tbody = this.props.recipients.map(function (row, index) {
            return (
                <tr key={index}>
                    <td>{row.company}</td>
                    <td>{row.recipient}</td>
                    <td style={CENTER} >{star(row.main)}</td>
                    <td>{row.area}</td>
                </tr>);
        }.bind(this));

        let modal = <div className="modal" id="formRecipients" ref={this.props.modalWindow} tabIndex="-1" role="dialog">
            <div key={this.props.keyForModal} className="modal-dialog" role="document">
                <div className="modal-content">
                    <div className="modal-header">
                        <h5 className="modal-title"><strong>Recipients</strong></h5>
                        <button type="button" className="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                        <div className="modal-body">
                            <div className="row">
                                <div className="col-md-12 table-responsive" style={{ 'maxHeight': '600px'}}>
                                    <table className="table table-condensed table-bordered table-striped table-hover">
                                        {thead}
                                        <tbody>
                                        {tbody}
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                        <div className="modal-footer">
                            <button type="button" className="btn btn-secondary" data-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>;
        return(<div>
            {modal}
        </div>);
    }
}
