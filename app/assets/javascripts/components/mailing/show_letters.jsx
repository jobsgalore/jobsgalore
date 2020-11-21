class ShowLetters extends React.Component{
    constructor(props){
        super(props);
        this.state = {
            letters: this.props.letters,
            currentListOfRecipients: []
        };
        this._modalWindow = React.createRef();
        this.handlerShowModal = this.handlerShowModal.bind(this);
        this.handlerDeleteLetter = this.handlerDeleteLetter.bind(this);
        this.handlerSynchronization = this.handlerSynchronization.bind(this);
        this.componentDidMount = this.componentDidMount.bind(this);
    }

    componentDidMount(){
        setTimeout(this.handlerSynchronization,20000);
    }

    handlerShowModal(index){
        this.setState({currentListOfRecipients: this.state.letters[index].recipients});
        $(this._modalWindow.current).modal('show');
    }


    handlerSynchronization(){
        $.ajax({
            type: "get",
            url: this.props.url_for_synchronization,
            success: function (data) {
                this.setState({letters: data});
            }.bind(this),
            dataType: 'json'
        });
        setTimeout(this.handlerSynchronization,20000);
    }

    handlerDeleteLetter(url, key){
        $.ajax({
            url: url,
            type: 'DELETE',
            success: function(result) {
                let array = this.state.letters;
                delete array[key];
                this.setState({letters: array});
            }.bind(this)
        });
    }


    render(){
        const CENTER = {"textAlign": "center", "verticalAlign": "middle"};
        let thead = <thead>
                        <tr>
                            <th className="hidden-xs col-md-1">Date Created</th>
                            <th className="hidden-xs col-md-1" >Recipients</th>
                            <th className="col-md-7 col-xs-10">Message</th>
                            <th className="col-md-1 col-xs-1">Amount</th>
                            <th className="hidden-xs col-md-1">Status</th>
                            <th className="col-md-1 col-xs-1">Action</th>
                        </tr>
                    </thead>;
        let tbody = this.state.letters.map(function (row, index) {
            let btnPay;
            if (row.pay_url !== null) {
                btnPay = <div className="btn_margin"><a className="btn btn-info btn-block" href={row.pay_url} onClick={() => {experiment('contacts_of_companies', 'Оплата')}}>Pay</a></div>;
            }
            return (
                <tr key={index}>
                    <td style={CENTER} className="hidden-xs">{row.created_at}</td>
                    <td style={CENTER} className="hidden-xs"><a onClick={() => this.handlerShowModal(index)}> Show </a></td>
                    <td  style={{'wordBreak': 'break-all'}}>{row.message}</td>
                    <td style={CENTER}>${row.amount.toFixed(2)}</td>
                    <td style={CENTER} className="hidden-xs">{row.status}</td>
                    <td style={CENTER}>
                        {btnPay}
                        <div className="btn_margin">
                            <a className="btn btn-danger btn-block" onClick={() => this.handlerDeleteLetter(row.destroy_url, index)}>Delete</a>
                        </div>
                    </td>
                </tr>);
        }.bind(this));
        let keyForModal = Math.floor(Math.random() * (10 - 1)) + 1;
        return(<div className="col-lg-8 col-md-9 col-sm-12">
                <h1> Mailbox</h1>
                    <ul className="nav nav-tabs">
                        <li className="active"><a>Mailbox</a></li>
                        <li><a href={this.props.newMessage}>Mailing List</a></li>
                    </ul>
                    <br />
                    <div className="row">
                        <div className="col-md-offset-9 col-md-3 hidden-xs hidden-sm">
                            <a className="btn btn-block btn-primary" href={this.props.newMessage}>New message</a>
                        </div>
                        <br/>
                        <br className="hidden-xs"/>
                        <br className="hidden-xs"/>
                        <div className="col-md-12">
                                <table className="table table-bordered table-striped table-hover">
                                    {thead}
                                    <tbody>
                                        {tbody}
                                    </tbody>
                                </table>
                        </div>
                    </div>
                <Recipients modalWindow = {this._modalWindow}
                            keyForModal = {keyForModal}
                            recipients = {this.state.currentListOfRecipients}/>
                <div className="hidden-lg hidden-md sticky">
                    <a className="btn btn-block btn-circle btn-primary" href={this.props.newMessage}>New message</a>
                </div>
                </div>
        );
    }

}