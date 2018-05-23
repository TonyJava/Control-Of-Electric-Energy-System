<?php
//defined('BASEPATH') OR exit('No direct script access allowed');

class Client extends CI_Controller {

    public function askExist(){
        $this->load->model('Bee', '', true);

        $macAddress=isset($_POST['macAddress']) ? $_POST['macAddress'] : '';

        if($macAddress!=''){
            $query=$this->Bee->askExist($macAddress);
            if($query){
                $this->_resultParsing("306");
                //echo $query->row()->location;
            } else {
                $this->_resultParsing("200&");
            }
        } else {
            $this->output->append_output("200");
            //$result=302;
            //$this->_resultParsing($result);
        }
    }

    public function insertAddress(){
        $this->load->model('Bee', '', true);

        $macAddress=isset($_POST['macAddress']) ? $_POST['macAddress'] : '';
        $location=isset($_POST['location']) ? $_POST['location'] : '';

        if($macAddress!='' && $location!=''){
            $query=$this->Bee->insertAddress($macAddress, $location);

            if($query){
                echo "200";
            } else {
                echo "401";
            }
        } else {
            echo "300";
        }
    }

    public function updateState(){
        $this->load->model('Bee', '', true);

        $macAddress = isset($_POST['macAddress']) ? $_POST['macAddress'] : '';
        $state = isset($_POST['state']) ? $_POST['state'] : '';

        if($macAddress!='' && $state!=''){
            $query=$this->Bee->updateState($macAddress, $state);

            if($query){
                echo "200";
            } else {
                echo "401";
            }
        } else {
            echo "300";
        }
    }

    public function updateShutdown(){
        $this->load->model('Bee', '', true);

        $macAddress = isset($_POST['macAddress']) ? $_POST['macAddress'] : '';

        if($macAddress!=''){
            $query=$this->Bee->updateShutdown($macAddress);

            if($query){
                echo "200";
            } else {
                echo "401";
            }
        } else {
            echo "300";
        }
    }

    private function _resultParsing($result){
        $data=array();
        $data['result']=$result;

        $this->load->view('clientParsing', $data);
    }
}
