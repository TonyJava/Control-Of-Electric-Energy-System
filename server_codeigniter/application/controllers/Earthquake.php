<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Earthquake extends CI_Controller {

    public function eqfind(){
        $this->load->model('Bee', '', true);

        $longitude=isset($_POST['longitude']) ? $_POST['longitude'] : '';
        $latitude=isset($_POST['latitude']) ? $_POST['latitude'] : '';
        $distance=isset($_POST['distance']) ? $_POST['distance'] : '';

        if($longitude!='' && $latitude!='' && $distance!=''){
            $query = $this->Bee->eqfind($longitude, $latitude, $distance);

            $result=array();
            foreach ($query->result_array() as $row){
                array_push($result, $row);

            }

            $this->_JSONParsing(200, 'Success', $result, '');
        } else{
            $this->_JSONParsing(300, 'Parameter is invalid', '', '');
        }
    }

    public function eqinfo(){
        $this->load->model('Bee', '', true);

        $longitude=isset($_POST['longitude']) ? $_POST['longitude'] : '';
        $latitude=isset($_POST['latitude']) ? $_POST['latitude'] : '';

        if($longitude!='' && $latitude!=''){
            $query = $this->Bee->eqinfo($longitude, $latitude);

            $result=array();
            foreach ($query->result_array() as $row){
                array_push($result, $row);

            }

            $this->_JSONParsing(200, 'Success', $result, '');
        } else{
            $this->_JSONParsing(300, 'Parameter is invalid', '', '');
        }
    }

    public function eqtest(){
        $this->load->model('Bee', '', true);

        $longitude=isset($_POST['longitude']) ? $_POST['longitude'] : '';
        $latitude=isset($_POST['latitude']) ? $_POST['latitude'] : '';

        if($longitude!='' && $latitude!=''){
            $query = $this->Bee->eqtest($longitude, $latitude);

            $result=array();
            foreach ($query->result_array() as $row){
                array_push($result, $row);

            }

            $this->_JSONParsing(200, 'Success', $result, '');
        } else{
            $this->_JSONParsing(300, 'Parameter is invalid', '', '');
        }
    }

    private function _JSONParsing($code, $message, $data, $token){
        $dataJSON=array();
        $dataJSON['code']=$code;
        $dataJSON['message']=$message;
        $dataJSON['data']=$data;
        $dataJSON['token']=$token;

        $this->load->view('jsonParsing', $dataJSON);
    }

    private function _encodingToJSON($data){
        return json_encode($data);
    }
}
?>
