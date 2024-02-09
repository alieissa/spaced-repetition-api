defmodule SpacedRep.TestUtils do
  def get_token(payload) do
    jwk_hs256 = JOSE.JWK.generate_key({:oct, 16})

    # HS256
    JOSE.JWT.sign(jwk_hs256, %{"alg" => "HS256"}, payload)
    |> JOSE.JWS.compact()
    |> elem(1)
  end
end
