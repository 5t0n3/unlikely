import gleam/bytes_builder
import gleam/erlang/process
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import gleam/string
import mist.{type Connection, type ResponseData}
import simplifile

const wordlist_size = 7776

const passphrase_len = 6

pub fn main() {
  let assert Ok(wordlist) =
    simplifile.read("resources/eff-wordlist.txt")
    |> result.map(string.split(_, "\n"))

  let not_found =
    response.new(404)
    |> response.set_body(mist.Bytes(bytes_builder.from_string("not found")))

  let assert Ok(_) =
    fn(req: Request(Connection)) -> Response(ResponseData) {
      case request.path_segments(req) {
        ["passphrase"] -> gen_passphrase_handler(wordlist)
        _ -> not_found
      }
    }
    |> mist.new
    |> mist.start_http

  process.sleep_forever()
}

fn gen_passphrase_handler(wordlist: List(String)) -> Response(ResponseData) {
  let max_step = wordlist_size / passphrase_len

  let passphrase =
    list.range(1, 6)
    |> list.fold(#([], wordlist), fn(acc, _) {
      let #(pass, wlist) = acc
      let drop_amt = int.random(max_step)
      let assert [word, ..new_wlist] = list.drop(wlist, drop_amt)
      #([word, ..pass], new_wlist)
    })
    |> pair.first
    |> list.shuffle
    |> string.join("-")

  response.new(200)
  |> response.set_body(mist.Bytes(bytes_builder.from_string(passphrase)))
}
